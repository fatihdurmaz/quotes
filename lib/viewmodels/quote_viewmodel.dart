import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote.dart';

class QuoteViewModel extends ChangeNotifier {
  List<Quote> _quotes = [];
  List<Quote> _filteredQuotes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Quote> get quotes => _filteredQuotes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Quote> get favoriteQuotes =>
      _quotes.where((quote) => quote.isFavorite).toList();

  QuoteViewModel() {
    fetchQuotes();
  }

  Future<void> fetchQuotes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await Dio().get('https://dummyjson.com/quotes');
      final List quotesJson = response.data['quotes'];
      _quotes = quotesJson.map((json) => Quote.fromJson(json)).toList();
      _filteredQuotes = _quotes;
      await loadFavorites();
    } catch (e) {
      _errorMessage = "Veri çekme hatası: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    if (query.isEmpty) {
      _filteredQuotes = _quotes;
    } else {
      _filteredQuotes =
          _quotes
              .where(
                (quote) =>
                    quote.quote.toLowerCase().contains(query.toLowerCase()) ||
                    quote.author.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    notifyListeners();
  }

  void toggleFavorite(int quoteId) {
    final index = _quotes.indexWhere((quote) => quote.id == quoteId);
    if (index != -1) {
      _quotes[index].isFavorite = !_quotes[index].isFavorite;
      notifyListeners();
      saveFavorites();
    }
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favoriteQuotes') ?? [];

    for (final id in favoriteIds) {
      final index = _quotes.indexWhere((quote) => quote.id.toString() == id);
      if (index != -1) {
        _quotes[index].isFavorite = true;
      }
    }
    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds =
        _quotes
            .where((quote) => quote.isFavorite)
            .map((quote) => quote.id.toString())
            .toList();

    await prefs.setStringList('favoriteQuotes', favoriteIds);
  }
}
