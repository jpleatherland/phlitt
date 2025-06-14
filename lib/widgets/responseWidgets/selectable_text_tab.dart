import 'package:flutter/material.dart';
import './highlight_text.dart';

class SelectableTextTab extends StatefulWidget {
  const SelectableTextTab({
    super.key,
    required this.isFetching,
    required this.responseBody,
  });

  final bool isFetching;
  final String responseBody;

  @override
  State<SelectableTextTab> createState() => _SelectableTextTabState();
}

class _SelectableTextTabState extends State<SelectableTextTab> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  Map<int, int> searchResult = {};
  int currentSearchIndex = 0;
  double heightPerLine = 0.0;

  void setScrollPoint(int index) {
    if (index > searchResult.length - 1) {
      if (searchResult.containsKey(0)) {
        scrollController.jumpTo(searchResult[0]!.toDouble() * heightPerLine);
        setState(() => currentSearchIndex = 0);
      }
    } else {
      if (searchResult.containsKey(index)) {
        scrollController
            .jumpTo(searchResult[index]!.toDouble() * heightPerLine);
        setState(() => currentSearchIndex = index);
      }
    }
  }

  void findMatches(String searchTerm) {
    if (searchTerm.isEmpty) return; // Don't search if the search term is empty

    List<String> splitBody = widget.responseBody.split('\n');
    int outerIndex = 0;
    Map<int, int> matches = {};
    for (int index = 0; index < splitBody.length; index++) {
      if (splitBody[index].contains(searchTerm)) {
        matches[outerIndex] = index;
        outerIndex++;
      }
    }

    setState(() {
      currentSearchIndex = 0;
      heightPerLine =
          scrollController.position.maxScrollExtent / splitBody.length;
      searchResult = matches;
    });

    if (matches.isNotEmpty) {
      setScrollPoint(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        'SelectableTextTab: responseBody length = [33m${widget.responseBody.length}[0m');
    if (widget.isFetching) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.responseBody.isEmpty) {
      print('SelectableTextTab: responseBody is empty, showing placeholder');
      return const Center(child: Text('No response body.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 5,
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(hintText: 'search'),
                onChanged: (value) {
                  // Delay search call slightly or trigger debouncing here if needed
                  findMatches(value);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Text(
                    '${searchResult.isNotEmpty ? currentSearchIndex + 1 : 0}/${searchResult.length}',
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setScrollPoint(currentSearchIndex - 1),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => setScrollPoint(currentSearchIndex + 1),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  findMatches(searchController.text);
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            controller: scrollController,
            child: SelectableText.rich(
              highlightText(
                widget.responseBody,
                searchController.text,
                const TextStyle(),
                const TextStyle(backgroundColor: Colors.yellowAccent),
                true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
