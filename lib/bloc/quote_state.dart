import '../models/quote.dart';

// Quote ile ilgili tüm state'leri tanımlayan abstract sınıf
abstract class QuoteState {}

// Başlangıç durumu
class QuoteInitial extends QuoteState {}

// Yükleme durumu
class QuoteLoading extends QuoteState {}

// Başarılı durum
class QuoteLoaded extends QuoteState {
  final List<Quote> quotes;
  final List<Quote> filteredQuotes;
  final List<Quote> favoriteQuotes;

  QuoteLoaded({
    required this.quotes,
    required this.filteredQuotes,
    required this.favoriteQuotes,
  });
}

// Hata durumu
class QuoteError extends QuoteState {
  final String message;
  QuoteError(this.message);
}
