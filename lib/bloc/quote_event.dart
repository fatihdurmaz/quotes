// Quote ile ilgili tüm event'leri tanımlayan abstract sınıf
abstract class QuoteEvent {}

// Alıntıları getirme event'i
class FetchQuotes extends QuoteEvent {}

// Alıntıları arama event'i
class SearchQuotes extends QuoteEvent {
  final String query;
  SearchQuotes(this.query);
}

// Favori durumunu değiştirme event'i
class ToggleFavorite extends QuoteEvent {
  final int quoteId;
  ToggleFavorite(this.quoteId);
}
