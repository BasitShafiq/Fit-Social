// Get started card options
import 'dart:convert';

import '../../model/get_started_page_card_choices_model.dart';

String cardsJson = '''[
    {
      "title": "inactive",
      "description": "I have never trained"
    },
    {
      "title": "beginner",
      "description": "I have trained few times"
    },
    {
      "title": "weak",
      "description": "I feel like i can train better"
    }
  ]''';

// you can just make list of ChoiceChip directly like :
// List<ChoiceCard> list = <ChoiceCard>[
//   ChoiceCard(title: "title here", description: "description here"),
//   ChoiceCard(title: "title here", description: "description here"),
//   ChoiceCard(title: "title here", description: "description here"),
// ];
// but I just don't want to since this is personal issue LOL, so I genrate em with factory
List<ChoiceCard> handledCardsList = List<ChoiceCard>.from(
  jsonDecode(cardsJson).map(
    (choiceCardJson) => ChoiceCard.fromJson(
      choiceCardJson,
    ),
  ),
);
