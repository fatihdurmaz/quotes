import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quotes/viewmodels/quote_viewmodel.dart';
import 'package:share_plus/share_plus.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuoteViewModel>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: viewModel.search,
              decoration: InputDecoration(
                hintText: "Alıntı veya yazar ara...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            viewModel.search('');
                            FocusScope.of(context).unfocus();
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(23),
                ),
              ),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (_) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset('assets/json/error.json'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => viewModel.fetchQuotes(),
                          child: const Text("Tekrar Dene"),
                        ),
                      ],
                    ),
                  );
                }

                if (viewModel.quotes.isEmpty) {
                  return const Center(child: Text("Hiç alıntı bulunamadı."));
                }

                return ListView.separated(
                  itemCount: viewModel.quotes.length,
                  itemBuilder: (context, index) {
                    final quote = viewModel.quotes[index];
                    return Dismissible(
                      key: Key(quote.id.toString()),
                      direction: DismissDirection.horizontal,
                      background: Container(
                        color: Colors.orange,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 16),
                        child: const Icon(Icons.share, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          final bool? confirm = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Silme Onayı"),
                                content: const Text(
                                  "Bu alıntıyı silmek istediğinize emin misiniz?",
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(false),
                                    child: const Text("İptal"),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(true),
                                    child: const Text("Sil"),
                                  ),
                                ],
                              );
                            },
                          );
                          return confirm;
                        } else {
                          await SharePlus.instance.share(
                            ShareParams(
                              text: '${quote.quote}\n${quote.author}',
                            ),
                          );

                          return false;
                        }
                      },
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          HapticFeedback.vibrate();

                          setState(() {
                            viewModel.quotes.removeAt(index);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Alıntı silindi."),
                              duration: Durations.long1,
                            ),
                          );
                        }
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueGrey.shade500,
                          foregroundColor: Colors.white,
                          child: Text((index + 1).toString()),
                        ),
                        title: Text(quote.quote),
                        subtitle: Text(
                          '- ${quote.author}',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            quote.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: quote.isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            viewModel.toggleFavorite(quote.id);

                            final message =
                                quote.isFavorite
                                    ? "Favorile eklendi"
                                    : "Favorilerden çıkarıldı";

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(thickness: 0.5);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
