import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotes/viewmodels/quote_viewmodel.dart';
import 'package:share_plus/share_plus.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuoteViewModel>(context);
    final favoriteQuotes = viewModel.favoriteQuotes;

    if (favoriteQuotes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Henüz favori alıntınız yok',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: favoriteQuotes.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final quote = favoriteQuotes[index];
        return Card(
          elevation: 2,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              quote.quote,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '- ${quote.author}',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () async {
                    await SharePlus.instance.share(
                      ShareParams(text: '${quote.quote}\n${quote.author}'),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    viewModel.toggleFavorite(quote.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Favorilerden çıkarıldı'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 8),
    );
  }
}
