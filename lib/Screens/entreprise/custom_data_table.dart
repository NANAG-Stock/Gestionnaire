//  Customize by @Nanajeremie to allow developer to use
//  easily the responsive_table plugin
//
//
// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';

class CustomDataTable extends StatefulWidget {
  // The list of data to be showed
  List<Map<String, dynamic>> data;
  // the list of headers to be showed
  final List headers;
  // boolean to fix the default sorting to ascending or not
  bool sortAscending;
  // Table header bgColor
  final Color headerBgColor;
  // header textStyle
  final TextStyle headerStyle;
  // row TextStyle
  final TextStyle rowStyle;
  // TextStyle for selected row
  final TextStyle selectStyle;
  // boolean to show the select checkboxes or not
  final bool showSelect;
  // the numbers of element for step
  int steps;
  // total of data
  final int totalItems;
  //  function to controle the next and back bouttons
  Function(int currentSteps, int step, bool isFront) nextStep;
  CustomDataTable({
    Key? key,
    required this.data,
    this.sortAscending = true,
    this.showSelect = true,
    required this.headers,
    required this.steps,
    required this.totalItems,
    required this.nextStep,
    this.headerBgColor = Colors.blue,
    this.headerStyle = const TextStyle(color: Colors.white),
    this.rowStyle = const TextStyle(color: Colors.black),
    this.selectStyle = const TextStyle(color: Colors.white),
  }) : super(key: key);
  @override
  DataPageState createState() => DataPageState();
}

class DataPageState extends State<CustomDataTable> {
  List<DatatableHeader> _headers = [];

  List<Map<String, dynamic>> _selecteds = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  String? _sortColumn;
  List<bool>? _expanded;

  @override
  void initState() {
    super.initState();
    _sourceFiltered = widget.data;
    _headers = _buidHeader(widget.data.first);

    _expanded = _buildExpended(widget.data);
  }

  @override
  void dispose() {
    super.dispose();
  }

// methode of building headers
  List<DatatableHeader> _buidHeader(Map<String, dynamic> sourceHeaders) {
    List<DatatableHeader> headears = [];
    int cpt = 0;
    sourceHeaders.forEach((key, value) {
      headears.add(
        DatatableHeader(
          text: widget.headers[cpt].toString(),
          value: key.toString(),
          show: true,
          sortable: true,
          sourceBuilder: key.toString() != "button"
              ? null
              : (value, row) {
                  return Container(
                    child: value,
                  );
                },
          textAlign: TextAlign.center,
        ),
      );
      cpt++;
    });

    return headears;
  }

  // methode for fill up the exppended list
  List<bool> _buildExpended(List sourceData) {
    List<bool> expends = [];
    for (var i = 0; i < sourceData.length; i++) {
      expends.add(false);
    }
    return expends;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveDatatable(
      reponseScreenSizes: const [
        ScreenSize.xs,
      ],
      actions: null,
      headers: _headers,
      source: widget.data,
      selecteds: _selecteds,
      expanded: _expanded,
      sortAscending: widget.sortAscending,
      showSelect: widget.showSelect,
      isLoading: false,
      sortColumn: _sortColumn,
      autoHeight: false,
      onChangedRow: (value, header) {
        // code here
      },
      onSubmittedRow: (value, header) {
        // code here
      },
      onTabRow: (data) {
        // code here
      },
      onSort: (value) {
        setState(() {
          _sortColumn = value;
          widget.sortAscending = !widget.sortAscending;
          if (widget.sortAscending) {
            _sourceFiltered
                .sort((a, b) => b["$_sortColumn"].compareTo(a["$_sortColumn"]));
          } else {
            _sourceFiltered
                .sort((a, b) => a["$_sortColumn"].compareTo(b["$_sortColumn"]));
          }
          widget.data = _sourceFiltered;
        });
      },
      onSelect: (value, item) {
        if (value!) {
          setState(() => _selecteds.add(item));
        } else {
          setState(() => _selecteds.removeAt(_selecteds.indexOf(item)));
        }
      },
      onSelectAll: (value) {
        if (value!) {
          setState(() =>
              _selecteds = widget.data.map((entry) => entry).toList().cast());
        } else {
          setState(() => _selecteds.clear());
        }
      },
      footers: [
        Row(
          children: [
            Text(
              widget.steps.toString(),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Sur',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.totalItems.toString(),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            )
          ],
        ),
        IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
            onPressed: () {
              widget.nextStep(widget.steps, widget.steps--, false);
            }),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: () {
            widget.nextStep(widget.steps, widget.steps++, true);
          },
          padding: const EdgeInsets.symmetric(horizontal: 15),
        )
      ],
      headerDecoration: BoxDecoration(
        color: widget.headerBgColor,
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.3), width: 1),
        ),
      ),
      selectedDecoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: widget.headerBgColor.withOpacity(0.8), width: 1)),
        color: widget.headerBgColor.withOpacity(0.3),
      ),
      headerTextStyle: widget.headerStyle,
      rowTextStyle: widget.rowStyle,
      selectedTextStyle: widget.selectStyle,
    );
  }
}
