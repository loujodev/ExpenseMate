import 'package:expense_mate/src/features/categorypage/presentation/add_category_page/add_category_page.dart';
import 'package:expense_mate/src/shared/domain/category_model.dart';
import 'package:flutter/material.dart';

///Map of different icons for categories and some ideas for naming them when creating [Category] objects on [AddCategoryPage].

final List<Map<String, dynamic>> expenseCategories = const [
  // Food & Dining
  {'value': 'Groceries', 'icon': Icons.shopping_basket},
  {'value': 'Restaurants', 'icon': Icons.restaurant},
  {'value': 'Coffee', 'icon': Icons.coffee},
  {'value': 'Fast Food', 'icon': Icons.fastfood},

  // Housing
  {'value': 'Rent', 'icon': Icons.home},
  {'value': 'Mortgage', 'icon': Icons.credit_card},
  {'value': 'Utilities', 'icon': Icons.bolt},
  {'value': 'Internet', 'icon': Icons.wifi},

  // Transportation
  {'value': 'Car Payment', 'icon': Icons.directions_car},
  {'value': 'Gas', 'icon': Icons.local_gas_station},
  {'value': 'Public Transit', 'icon': Icons.directions_bus},
  {'value': 'Ride Share', 'icon': Icons.directions_car},

  // Entertainment
  {'value': 'Movies', 'icon': Icons.movie},
  {'value': 'Games', 'icon': Icons.videogame_asset},
  {'value': 'Sports', 'icon': Icons.sports_soccer},
  {'value': 'Books', 'icon': Icons.menu_book},

  // Subscriptions
  {'value': 'Streaming', 'icon': Icons.live_tv},
  {'value': 'Music', 'icon': Icons.music_note},
  {'value': 'Gym', 'icon': Icons.fitness_center},
  {'value': 'Cloud Storage', 'icon': Icons.cloud},

  // Savings & Investments
  {'value': 'Savings', 'icon': Icons.savings},
  {'value': 'Investments', 'icon': Icons.trending_up},
  {'value': 'Retirement', 'icon': Icons.account_balance},
  {'value': 'Interest', 'icon': Icons.monetization_on},

  // Other
  {'value': 'Healthcare', 'icon': Icons.local_hospital},
  {'value': 'Shopping', 'icon': Icons.shopping_cart},
  {'value': 'Travel', 'icon': Icons.flight},
];
