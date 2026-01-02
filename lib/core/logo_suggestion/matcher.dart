import 'package:passave/core/logo_suggestion/logo_suggestion.dart';

String normalize(String s) =>
    s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
bool inOrderMatch(String input, String target) {
  int i = 0;
  for (final c in target.split('')) {
    if (i < input.length && c == input[i]) i++;
  }
  return i == input.length;
}

List<LogoSuggestion> matchLogos(String query) {
  final q = normalize(query);
  if (q.isEmpty) return [];

  final scored = <({LogoSuggestion s, int score})>[];

  for (final s in logos) {
    final name = normalize(s.name);
    int score = 0;

    if (name.contains(q)) score += 100;
    if (inOrderMatch(q, name)) score += 60;

    final dist = levenshtein(q, name);
    if (dist <= 3) score += (80 - dist * 20);

    if (score > 0) {
      scored.add((s: s, score: score));
    }
  }

  scored.sort((a, b) => b.score.compareTo(a.score));
  return scored.take(5).map((e) => e.s).toList();
}

int levenshtein(String s, String t) {
  if (s.length < t.length) {
    final temp = s;
    s = t;
    t = temp;
  }

  List<int> previous = List.generate(t.length + 1, (i) => i);

  for (int i = 1; i <= s.length; i++) {
    List<int> current = List.filled(t.length + 1, 0);
    current[0] = i;

    for (int j = 1; j <= t.length; j++) {
      final cost = s[i - 1] == t[j - 1] ? 0 : 1;
      current[j] = [
        current[j - 1] + 1,
        previous[j] + 1,
        previous[j - 1] + cost,
      ].reduce((a, b) => a < b ? a : b);
    }

    previous = current;
  }

  return previous[t.length];
}

bool looksLikeDomain(String input) {
  final text = input.toLowerCase();
  if (!text.contains('.')) return false;
  if (text.contains(' ')) return false;
  final parts = text.split('.');
  if (parts.any((p) => p.isEmpty)) return false;
  final tld = parts.last;
  if (tld.length < 2 || !RegExp(r'^[a-z]+$').hasMatch(tld)) {
    return false;
  }
  return true;
}

String extractDomain(String input) {
  var text = input.toLowerCase();
  text = text.replaceFirst(RegExp(r'^https?://'), '');
  final slashIndex = text.indexOf('/');
  if (slashIndex != -1) {
    text = text.substring(0, slashIndex);
  }
  if (text.startsWith('www.')) {
    text = text.substring(4);
  }
  return text;
}
