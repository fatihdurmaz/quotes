import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote.dart';
import 'quote_event.dart';
import 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  // Dio instance'ı
  final Dio _dio = Dio();

  // Tüm alıntılar
  List<Quote> _quotes = [];

  // Filtrelenmiş alıntılar
  List<Quote> _filteredQuotes = [];

  QuoteBloc() : super(QuoteInitial()) {
    // Event'leri dinleme ve işleme
    on<FetchQuotes>(_onFetchQuotes);
    on<SearchQuotes>(_onSearchQuotes);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  // Alıntıları getirme işlemi
  Future<void> _onFetchQuotes(
    FetchQuotes event,
    Emitter<QuoteState> emit,
  ) async {
    emit(QuoteLoading());
    try {
      final response = await _dio.get('https://dummyjson.com/quotes');
      final List quotesJson = response.data['quotes'];
      _quotes = quotesJson.map((json) => Quote.fromJson(json)).toList();
      _filteredQuotes = _quotes;
      await _loadFavorites();

      emit(
        QuoteLoaded(
          quotes: _quotes,
          filteredQuotes: _filteredQuotes,
          favoriteQuotes: _getFavoriteQuotes(),
        ),
      );
    } catch (e) {
      emit(QuoteError("Veri çekme hatası: $e"));
    }
  }

  // Alıntıları arama işlemi
  void _onSearchQuotes(SearchQuotes event, Emitter<QuoteState> emit) {
    if (event.query.isEmpty) {
      _filteredQuotes = _quotes;
    } else {
      _filteredQuotes =
          _quotes
              .where(
                (quote) =>
                    quote.quote.toLowerCase().contains(
                      event.query.toLowerCase(),
                    ) ||
                    quote.author.toLowerCase().contains(
                      event.query.toLowerCase(),
                    ),
              )
              .toList();
    }

    emit(
      QuoteLoaded(
        quotes: _quotes,
        filteredQuotes: _filteredQuotes,
        favoriteQuotes: _getFavoriteQuotes(),
      ),
    );
  }

  // Favori durumunu değiştirme işlemi
  void _onToggleFavorite(ToggleFavorite event, Emitter<QuoteState> emit) {
    final index = _quotes.indexWhere((quote) => quote.id == event.quoteId);
    if (index != -1) {
      _quotes[index].isFavorite = !_quotes[index].isFavorite;
      _saveFavorites();

      emit(
        QuoteLoaded(
          quotes: _quotes,
          filteredQuotes: _filteredQuotes,
          favoriteQuotes: _getFavoriteQuotes(),
        ),
      );
    }
  }

  // Favori alıntıları getirme
  List<Quote> _getFavoriteQuotes() {
    return _quotes.where((quote) => quote.isFavorite).toList();
  }

  // Favori alıntıları yükleme
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favoriteQuotes') ?? [];

    for (final id in favoriteIds) {
      final index = _quotes.indexWhere((quote) => quote.id.toString() == id);
      if (index != -1) {
        _quotes[index].isFavorite = true;
      }
    }
  }

  // Favori alıntıları kaydetme
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds =
        _quotes
            .where((quote) => quote.isFavorite)
            .map((quote) => quote.id.toString())
            .toList();

    await prefs.setStringList('favoriteQuotes', favoriteIds);
  }
}
