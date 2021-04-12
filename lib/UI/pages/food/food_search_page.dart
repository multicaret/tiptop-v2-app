import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/input/app_search_field.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/food/categories_slider.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/home.dart';
import 'package:tiptop_v2/models/search.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/providers/restaurants_provider.dart';
import 'package:tiptop_v2/providers/search_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';

class FoodSearchPage extends StatefulWidget {
  static const routeName = '/food-search';

  @override
  _FoodSearchPageState createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  bool _isInit = true;
  bool _isLoading = false;

  String searchQuery = '';
  TextEditingController searchFieldController = new TextEditingController();
  FocusNode searchFieldFocusNode = new FocusNode();

  RestaurantsProvider restaurantsProvider;
  SearchProvider searchProvider;
  AppProvider appProvider;
  HomeProvider homeProvider;

  List<Branch> _searchedRestaurants = [];
  List<Term> _terms = [];

  @override
  void dispose() {
    searchFieldController.dispose();
    searchFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
      restaurantsProvider = Provider.of<RestaurantsProvider>(context, listen: false);
      searchProvider = Provider.of<SearchProvider>(context);

      fetchAndSetSearchTerms();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> fetchAndSetSearchTerms() async {
    setState(() => _isLoading = true);
    await searchProvider.fetchAndSetSearchTerms(selectedChannel: homeProvider.selectedChannel);
    _terms = searchProvider.terms;
    setState(() => _isLoading = false);
  }

  void _clearSearchResults() {
    searchFieldController.clear();
    searchFieldFocusNode.unfocus();
    setState(() {
      _searchedRestaurants = [];
      searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasCurve: false,
      appBar: AppBar(
        title: Text(Translations.of(context).get('Search')),
        actions: [
          if (_searchedRestaurants.isNotEmpty)
            IconButton(
              onPressed: _clearSearchResults,
              icon: AppIcons.icon(FontAwesomeIcons.eraser),
            )
        ],
      ),
      body: _isLoading
          ? const AppLoader()
          : Column(
              children: [
                AppSearchField(
                  submitAction: (String searchQuery) => submitFoodSearch(searchQuery),
                  controller: searchFieldController,
                  focusNode: searchFieldFocusNode,
                ),
                _searchedRestaurants.isNotEmpty
                    ? SectionTitle(
                        'Search Results',
                        suffix: ' (${_searchedRestaurants.length})',
                      )
                    : Column(
                        children: [
                          SectionTitle('Categories'),
                          CategoriesSlider(
                            categories: restaurantsProvider.foodCategories,
                            isRTL: appProvider.isRTL,
                            onCategoryTap: (String categoryTitle) {
                              searchFieldController.text = categoryTitle;
                              searchFieldFocusNode.requestFocus();
                              submitFoodSearch(categoryTitle);
                            },
                          ),
                          SectionTitle('Most Searched Terms'),
                        ],
                      ),
                _searchedRestaurants.isNotEmpty
                    ? Expanded(
                        child: Container(
                          color: AppColors.white,
                          child: ListView.builder(
                            itemCount: _searchedRestaurants.length,
                            itemBuilder: (c, i) => Text(_searchedRestaurants[i].title),
                          ),
                        ),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [..._getMostSearchedTermsList()],
                          ),
                        ),
                      ),
              ],
            ),
    );
  }

  List<Widget> _getMostSearchedTermsList() {
    return List.generate(
      _terms.length,
      (i) => Material(
        color: AppColors.white,
        child: InkWell(
          onTap: () {
            searchFieldController.text = _terms[i].term;
            searchFieldFocusNode.requestFocus();
            submitFoodSearch(_terms[i].term);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
            child: Row(
              children: [
                AppIcons.iconSecondary(FontAwesomeIcons.infoCircle),
                const SizedBox(width: 10),
                Text(_terms[i].term),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitFoodSearch(String _searchQuery) async {
    print("_searchQuery");
    print(_searchQuery);
    if (searchQuery != _searchQuery) {
      setState(() {
        searchQuery = _searchQuery;
        _isLoading = true;
      });
      await restaurantsProvider.fetchSearchedRestaurants(_searchQuery);
      _searchedRestaurants = restaurantsProvider.searchedRestaurants;
      if (_searchedRestaurants.isEmpty) {
        showToast(msg: Translations.of(context).get('No results match your search'));
      } else {
        var key = 'result${_searchedRestaurants.length > 1 ? "s" : ""} match your search';
        showToast(msg: '${_searchedRestaurants.length} ${Translations.of(context).get(key)}');
      }
      fetchAndSetSearchTerms();
      setState(() {
        _isLoading = false;
      });
    }
  }
}
