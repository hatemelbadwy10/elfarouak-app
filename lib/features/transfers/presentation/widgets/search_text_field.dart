import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../data/model/auto_complete_model.dart';
import '../controller/transfer_bloc.dart';

class SearchTextField extends StatelessWidget {
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
    required this.listType, this.onSuggestionSelected,

  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        log('Current state in build: ${state.runtimeType}');

        return TypeAheadField<AutoCompleteModel>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: textEditingController,
            autofocus: false,
            keyboardType: textInputType,
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              labelText: label,
            ),
            onChanged: (pattern) {
              // Trigger the autocomplete event when text changes and meets minimum length
              if (pattern.length > 3) {
                log('Triggering autocomplete for: $pattern');
                BlocProvider.of<TransferBloc>(context).add(
                  FetchAutoCompleteEvent(
                      listType: listType, searchText: pattern),
                );
              }
            },
          ),
          suggestionsCallback: (pattern) async {
            log('suggestionsCallback called with pattern: $pattern');

            // Get the current state from the bloc
            final currentState = context.read<TransferBloc>().state;

            // If we have successful autocomplete data, return it
            if (currentState is AutoCompleteSuccess) {
              log('Returning ${currentState.autoCompleteList.length} suggestions from AutoCompleteSuccess state');
              return currentState.autoCompleteList;
            }

            // Return empty list for other states
            return [];
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
            // Show different message based on state
            if (state is AutoCompleteLoading) {
              return const ListTile(
                title: Center(child: Text('Loading...')),
              );
            } else if (state is AutoCompleteFailure) {
              return ListTile(
                title: Center(child: Text('Error: ${state.errMessage}')),
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
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion.label),
            );
          },
          onSuggestionSelected: onSuggestionSelected!
        );
      },
    );
  }
}
