import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quotes/viewmodels/quote_viewmodel.dart';

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
                  borderRadius: BorderRadius.circular(12),
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
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade500,
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
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
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
