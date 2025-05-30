import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../data/model/auto_complete_model.dart';
import '../controller/transfer_bloc.dart';

class SearchTextField extends StatefulWidget {
  final String? label;
  final TextEditingController? textEditingController;
  final TextInputType textInputType;
  final String listType;
  final Function(AutoCompleteModel)? onSuggestionSelected;

  const SearchTextField({
    super.key,
    this.label,
    this.textEditingController,
    this.textInputType = TextInputType.text,
    required this.listType,
    this.onSuggestionSelected,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  List<AutoCompleteModel> _suggestions = [];
  bool _isLoading = false;
  String? _error;

  // Map to store completers for each search pattern
  final Map<String, Completer<List<AutoCompleteModel>>> _completers = {};

  // Cache to store results
  final Map<String, List<AutoCompleteModel>> _cachedResults = {};

  @override
  void dispose() {
    // Complete any pending completers to avoid memory leaks
    for (var completer in _completers.values) {
      if (!completer.isCompleted) {
        completer.complete(<AutoCompleteModel>[]);
      }
    }
    _completers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransferBloc, TransferState>(
      listener: (context, state) {
        if (state is AutoCompleteSuccess) {
          setState(() {
            _suggestions = state.autoCompleteList;
            _isLoading = false;
            _error = null;
          });

          // Find the completer for the current search and complete it
          _completeCurrentSearch(state.autoCompleteList);

        } else if (state is AutoCompleteLoading) {
          setState(() {
            _isLoading = true;
            _error = null;
          });
        } else if (state is AutoCompleteFailure) {
          setState(() {
            _isLoading = false;
            _error = state.errMessage;
            _suggestions = [];
          });

          // Complete with empty list on failure
          _completeCurrentSearch(<AutoCompleteModel>[]);
        }
      },
      child: TypeAheadField<AutoCompleteModel>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: widget.textEditingController,
          autofocus: false,
          keyboardType: widget.textInputType,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            labelText: widget.label,
          ),
        ),
        suggestionsCallback: (pattern) async {
          log('suggestionsCallback called with pattern: $pattern');

          // If pattern is too short, return empty list
          if (pattern.length < 3) {
            return <AutoCompleteModel>[];
          }

          // Check if we have cached results for this pattern
          if (_cachedResults.containsKey(pattern)) {
            log('Returning cached results for: $pattern');
            return _cachedResults[pattern]!;
          }

          // Create a completer for this search pattern
          final completer = Completer<List<AutoCompleteModel>>();
          _completers[pattern] = completer;

          // Trigger the BLoC event
          BlocProvider.of<TransferBloc>(context).add(
            FetchAutoCompleteEvent(
                listType: widget.listType, searchText: pattern),
          );

          try {
            // Wait for the result with a timeout
            final result = await completer.future.timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                log('Search timeout for pattern: $pattern');
                return <AutoCompleteModel>[];
              },
            );

            // Cache the result
            _cachedResults[pattern] = result;

            return result;
          } catch (e) {
            log('Error in suggestions callback: $e');
            return <AutoCompleteModel>[];
          } finally {
            // Clean up the completer
            _completers.remove(pattern);
          }
        },
        loadingBuilder: (context) {
          return const ListTile(
            title: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error) {
          return ListTile(
            title: Center(
              child: Text('Error: $error'),
            ),
          );
        },
        noItemsFoundBuilder: (context) {
          if (_isLoading) {
            return const ListTile(
              title: Center(child: CircularProgressIndicator()),
            );
          } else if (_error != null) {
            return ListTile(
              title: Center(child: Text('Error: $_error')),
            );
          } else {
            return const ListTile(
              title: Center(child: Text('No results found')),
            );
          }
        },
        keepSuggestionsOnLoading: false,
        hideSuggestionsOnKeyboardHide: true,
        minCharsForSuggestions: 3,
        debounceDuration: const Duration(milliseconds: 300),
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.label),
          );
        },
        onSuggestionSelected: widget.onSuggestionSelected!,
      ),
    );
  }

  void _completeCurrentSearch(List<AutoCompleteModel> results) {
    // Complete all pending completers with the results
    // In a more sophisticated implementation, you might want to match
    // the completer with the specific search pattern
    final completersToComplete = Map.from(_completers);
    for (var entry in completersToComplete.entries) {
      if (!entry.value.isCompleted) {
        entry.value.complete(results);
      }
    }
  }
}