/// Validador de conteúdo ofensivo com normalização e fuzzy matching.
///
/// Detecta variações de palavras proibidas usando:
/// 1. Normalização (acentos, leetspeak, letras repetidas)
/// 2. Comparação exata E por similaridade (Levenshtein)
/// 3. Detecção em texto contínuo (sem espaços)
class ContentFilter {
  ContentFilter._();

  /// Palavras proibidas em português (base + variações comuns)
  static final List<String> _palavrasProibidas = [
    // Sexuais / órgãos
    'buceta', 'boceta', 'xoxota', 'xochota', 'xana', 'chochota',
    'pica', 'pinto', 'pênis', 'penis', 'pau', 'caralho', 'cacete',
    'cona', 'grelho', 'clitoris', 'clitóris', 'ânus', 'anus',
    'bumbum', 'peito', 'mama', 'seios',

    // Xingamentos
    'viado', 'veado', 'bicha', 'boiola', 'baitola', 'traveco',
    'puta', 'puto', 'vadia', 'vagabunda', 'piranha', 'corno',
    'corna', 'corno', 'fdp', 'filho da puta', 'arrombado',
    'otário', 'otario', 'idiota', 'imbecil', 'burro', 'burra',
    'bosta', 'merda', 'porra', 'caraca',

    // Atos sexuais
    'foder', 'fodase', 'foda-se', 'transar', 'trepar', 'gozar',
    'chupar', 'mamar', 'queca', 'sacanagem', 'punheta', 'esporra',

    // Drogas
    'cocaína', 'cocaina', 'maconha', 'heroína', 'heroina',
    'crack', 'metanfetamina',

    // Racismo / intolerância
    'ariano', 'racista', 'nazista', 'hitler',

    // Violência / ameaça
    'matar', 'morrer', 'suicídio', 'suicidio', 'estuprar',
    'estupro', 'pedófilo', 'pedofilo', 'pedofilia',
  ];

  /// Verifica se o texto contém conteúdo ofensivo.
  /// Retorna `true` se for considerado ofensivo.
  static bool hasProfanity(String texto) {
    if (texto.trim().isEmpty) return false;

    final normalizado = _normalizar(texto);

    // 1) Verifica se alguma palavra proibida está contida no texto normalizado
    for (final proibida in _palavrasProibidas) {
      if (normalizado.contains(proibida)) return true;
    }

    // 2) Verifica similaridade por token (para variações como "v1ad0")
    final tokens = _extrairTokens(texto);
    for (final token in tokens) {
      for (final proibida in _palavrasProibidas) {
        if (_similar(token, proibida)) return true;
      }
    }

    return false;
  }

  /// Retorna a primeira palavra proibida encontrada (útil para debug).
  static String? primeiraPalavraProibida(String texto) {
    if (texto.trim().isEmpty) return null;

    final normalizado = _normalizar(texto);
    for (final proibida in _palavrasProibidas) {
      if (normalizado.contains(proibida)) return proibida;
    }

    final tokens = _extrairTokens(texto);
    for (final token in tokens) {
      for (final proibida in _palavrasProibidas) {
        if (_similar(token, proibida)) return proibida;
      }
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────
  // INTERNOS
  // ─────────────────────────────────────────────────────────

  /// Normaliza o texto: minúsculas, remove acentos, converte leetspeak,
  /// colapsa letras repetidas (3+).
  static String _normalizar(String texto) {
    var t = texto.toLowerCase();

    // Remove acentos
    t = t
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ä', 'a')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('ë', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ì', 'i')
        .replaceAll('î', 'i')
        .replaceAll('ï', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ò', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('ö', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ù', 'u')
        .replaceAll('û', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ç', 'c')
        .replaceAll('ñ', 'n');

    // Converte leetspeak
    const leet = {
      '0': 'o',
      '1': 'i',
      '3': 'e',
      '4': 'a',
      '5': 's',
      '7': 't',
      '8': 'b',
      '9': 'g',
      '@': 'a',
      '\$': 's',
    };
    leet.forEach((k, v) => t = t.replaceAll(k, v));

    // Remove pontuação e separadores, mantém só letras e números
    t = t.replaceAll(RegExp(r'[^a-z0-9]'), '');

    // Colapsa letras repetidas (3+): "vuuuceta" → "vuceta"
    t = t.replaceAllMapped(
      RegExp(r'(.)\1{2,}'),
      (m) => m.group(1)! * 2, // deixa 2, tipo "vuceta" tem 2 u? não, deixa 1
    );
    t = t.replaceAllMapped(RegExp(r'(.)\1+'), (m) => m.group(1)!);

    return t;
  }

  /// Extrai tokens do texto: palavras separadas E o texto colado.
  static List<String> _extrairTokens(String texto) {
    final normalizado = _normalizar(texto);
    final tokens = <String>{normalizado};

    // Também quebra o texto em palavras (por espaços/pontuação)
    final palavras = texto
        .toLowerCase()
        .split(RegExp(r'[\s\-_.,;:!?*&/\\|]+'))
        .where((p) => p.isNotEmpty);

    for (final p in palavras) {
      final np = _normalizar(p);
      if (np.isNotEmpty) tokens.add(np);
    }

    return tokens.toList();
  }

  /// Verifica similaridade entre duas strings usando distância de Levenshtein.
  /// Retorna `true` se forem iguais ou muito parecidas (tolerância por tamanho).
  static bool _similar(String a, String b) {
    if (a == b) return true;
    if (a.isEmpty || b.isEmpty) return false;

    // Se as palavras têm tamanhos muito diferentes, ignora
    final diff = (a.length - b.length).abs();
    if (diff > 2) return false;

    // Tolerância: 1 caractere para palavras curtas, 2 para longas
    final maxDist = b.length <= 5 ? 1 : 2;

    return _levenshtein(a, b) <= maxDist;
  }

  /// Distância de Levenshtein (número mínimo de edições).
  static int _levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final linha = List<int>.generate(b.length + 1, (i) => i);

    for (var i = 1; i <= a.length; i++) {
      var anterior = linha[0];
      linha[0] = i;

      for (var j = 1; j <= b.length; j++) {
        final temp = linha[j];
        final custo = a[i - 1] == b[j - 1] ? 0 : 1;
        linha[j] = _min3(
          linha[j] + 1, // deleção
          linha[j - 1] + 1, // inserção
          anterior + custo, // substituição
        );
        anterior = temp;
      }
    }

    return linha[b.length];
  }

  static int _min3(int x, int y, int z) {
    final m = x < y ? x : y;
    return m < z ? m : z;
  }
}
