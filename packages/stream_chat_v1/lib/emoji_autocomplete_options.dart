import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';

import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:substring_highlight/substring_highlight.dart';

/// Overlay for displaying emoji that can be used
class StreamEmojiAutocompleteOptions extends StatelessWidget {
  /// Constructor for creating a [StreamEmojiAutocompleteOptions]
  const StreamEmojiAutocompleteOptions({
    super.key,
    required this.query,
    this.onEmojiSelected,
  });

  /// Query for searching emoji.
  final String query;

  /// Callback called when an emoji is selected.
  final ValueSetter<Emoji>? onEmojiSelected;

  @override
  Widget build(BuildContext context) {
    final emojis = Emoji.all().where((it) {
      final normalizedQuery = query.toUpperCase();
      final normalizedShortName = it.shortName.toUpperCase();

      return normalizedShortName.contains(normalizedQuery);
    });
    if (emojis.isEmpty) return const SizedBox.shrink();

    return StreamAutocompleteOptions<Emoji>(
      options: emojis,
      optionBuilder: (context, emoji) {
        final themeData = Theme.of(context);
        return ListTile(
          dense: true,
          horizontalTitleGap: 0,
          leading: Text(
            emoji.char,
            style: themeData.textTheme.headline6!.copyWith(
              fontSize: 24,
            ),
          ),
          title: SubstringHighlight(
            text: emoji.shortName,
            term: query,
            textStyleHighlight: themeData.textTheme.headline6!.copyWith(
              color: Colors.yellow,
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
            ),
            textStyle: themeData.textTheme.headline6!.copyWith(
              fontSize: 14.5,
            ),
          ),
          onTap: onEmojiSelected == null ? null : () => onEmojiSelected!(emoji),
        );
      },
    );
  }
}
