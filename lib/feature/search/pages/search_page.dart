import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart'; 

import 'package:store_app/feature/home/managers/home/product_bloc.dart'
    show ProductBloc;
import 'package:store_app/feature/home/managers/home/product_event.dart'
    show SearchProductsEvent;
import 'package:store_app/feature/home/managers/home/product_state.dart'
    show ProductState, ProductStatus;

import 'package:store_app/feature/search/managers/search_bloc.dart'
    show SearchBloc;
import 'package:store_app/feature/search/managers/search_event.dart'
    show AddRecentSearch, LoadRecentSearches;

import '../../../data/model/home/product_model.dart';
import 'package:store_app/feature/home/widgets/product_card_widgete.dart';

class SearchPage extends StatefulWidget {
  final List<ProductModel> allProducts;
  const SearchPage({super.key, required this.allProducts});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchBloc>().add(const LoadRecentSearches());
    });
  }
  Future<bool> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;

    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }

    if (status.isDenied) {
      print("User denied microphone permission");
      return false;
    }

    if (status.isPermanentlyDenied) {
      print("Permission permanently denied, open app settings");
      openAppSettings();
      return false;
    }

    return status.isGranted;
  }

  Future<void> _listen() async {
    bool hasPermission = await requestMicrophonePermission();
    if (!hasPermission) return;

    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (val) {
          print('SpeechToText error: $val');
          setState(() => _isListening = false);
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            _controller.text = val.recognizedWords;
            context.read<ProductBloc>().add(
                  SearchProductsEvent(_controller.text, widget.allProducts),
                );
          },
        );
      }
    } else {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Search",
        arrow: "assets/arrow.png",
        first: "assets/notifaction.png",
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                children: [
                  
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                           Image.asset("assets/search.png", width: 20,height: 20,),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              onChanged: (value) {
                                context.read<ProductBloc>().add(
                                      SearchProductsEvent(
                                          value, widget.allProducts),
                                    );
                              },
                              onSubmitted: (value) {
                                final text = value.trim();
                                if (text.isNotEmpty) {
                                  context
                                      .read<SearchBloc>()
                                      .add(AddRecentSearch(text));
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: "Search for clothes...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isListening ? Icons.mic : Icons.mic_none,
                              color: _isListening ? Colors.red :  theme.colorScheme.outline
                            ),
                            onPressed: _listen,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state.status == ProductStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_controller.text.isEmpty) {
                    return Center(
                      child: Text(
                        "Start typing or use mic to search",
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.inverseSurface,
                        ),
                      ),
                    );
                  }
                  if (state.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/search.png", height: 150),
                          const SizedBox(height: 16),
                          Text(
                            "No Results Found!",
                            style: TextStyle(
                              color: theme.colorScheme.inverseSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Try a similar word or use voice search.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.colorScheme.inverseSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.70,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return ProductCard(product: product);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
