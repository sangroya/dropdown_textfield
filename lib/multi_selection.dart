import 'package:dropdown_textfield/tooltip_widget.dart';
import 'package:flutter/material.dart';

import 'dropdown_textfield.dart';

class MultiSelection extends StatefulWidget {
  const MultiSelection(
      {Key? key,
      required this.onChanged,
      required this.dropDownList,
      required this.list,
      required this.height,
      this.buttonColor,
      this.buttonText,
      this.buttonTextStyle,
      required this.listTileHeight,
      required this.listPadding,
      this.listTextStyle,
      required this.searchFocusNode,
      required this.mainFocusNode,
      this.searchKeyboardType,
      required this.searchAutofocus,
      this.onSearchTap,
      this.initialBasedOnValue,
      required this.enableSearch,
      this.onSearchSubmit,
      this.searchShowCursor,
      this.searchDecoration,
      this.buttonPadding,
      this.checkBoxProperty,
      this.clearIconProperty})
      : super(key: key);

  final bool? initialBasedOnValue;
  final bool enableSearch;
  final double searchHeight = 60;
  final FocusNode searchFocusNode;
  final FocusNode mainFocusNode;
  final TextInputType? searchKeyboardType;
  final bool searchAutofocus;
  final bool? searchShowCursor;
  final Function? onSearchTap;
  final Function? onSearchSubmit;
  final InputDecoration? searchDecoration;
  final IconProperty? clearIconProperty;
  final EdgeInsets? buttonPadding;

  final List<DropDownValueModel> dropDownList;
  final ValueSetter onChanged;
  final List<bool> list;
  final double height;
  final Color? buttonColor;
  final String? buttonText;
  final TextStyle? buttonTextStyle;
  final double listTileHeight;
  final TextStyle? listTextStyle;
  final ListPadding listPadding;
  final CheckBoxProperty? checkBoxProperty;

  @override
  _MultiSelectionState createState() => _MultiSelectionState();
}

class _MultiSelectionState extends State<MultiSelection> {
  List<bool> multiSelectionValue = [];
  List<bool> newSelectionValue = [];
  late List<DropdownItem> newDropDownList;
  late TextEditingController _searchCnt;
  late FocusScopeNode _focusScopeNode;
  late InputDecoration _inpDec;

  @override
  void initState() {
    multiSelectionValue = List.from(widget.list);
    super.initState();

    _focusScopeNode = FocusScopeNode();
    _inpDec = widget.searchDecoration ?? InputDecoration();
    if (widget.searchAutofocus) {
      widget.searchFocusNode.requestFocus();
    }

    newDropDownList = [];
    widget.dropDownList.asMap().forEach((index, item) {
      newDropDownList.add(DropdownItem(value: item, originalIndex: index));
    });
    _searchCnt = TextEditingController();
  }

  @override
  void dispose() {
    _searchCnt.dispose();
    super.dispose();
  }

  onItemChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        newDropDownList = [];
        widget.dropDownList.asMap().forEach((index, item) {
          newDropDownList.add(DropdownItem(value: item, originalIndex: index));
        });
      } else {
        newDropDownList = [];
        newSelectionValue = [];
        widget.dropDownList.asMap().forEach((index, item) {
          if (item.name.toLowerCase().contains(value.toLowerCase())) {
            newDropDownList
                .add(DropdownItem(value: item, originalIndex: index));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.enableSearch)
          SizedBox(
            height: widget.searchHeight,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                focusNode: widget.searchFocusNode,
                showCursor: widget.searchShowCursor,
                keyboardType: widget.searchKeyboardType,
                controller: _searchCnt,
                onTap: () {
                  if (widget.onSearchTap != null) {
                    widget.onSearchTap!();
                  }
                },
                decoration: _inpDec.copyWith(
                  hintText: _inpDec.hintText ?? 'Search Here...',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      widget.mainFocusNode.requestFocus();
                      _searchCnt.clear();
                      onItemChanged("");
                    },
                    child: widget.searchFocusNode.hasFocus
                        ? InkWell(
                            child: Icon(
                              widget.clearIconProperty?.icon ?? Icons.close,
                              size: widget.clearIconProperty?.size,
                              color: widget.clearIconProperty?.color,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                onChanged: onItemChanged,
                onSubmitted: (val) {
                  widget.mainFocusNode.requestFocus();
                  if (widget.onSearchSubmit != null) {
                    widget.onSearchSubmit!();
                  }
                },
              ),
            ),
          ),
        SizedBox(
          height: widget.height,
          child: Scrollbar(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: newDropDownList.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: widget.listTileHeight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: widget.listPadding.bottom,
                          top: widget.listPadding.top),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        newDropDownList[index].value.name,
                                        style: widget.listTextStyle),
                                  ),
                                  if (newDropDownList[index].value.toolTipMsg !=
                                      null)
                                    ToolTipWidget(
                                        msg: newDropDownList[index]
                                            .value
                                            .toolTipMsg!)
                                ],
                              ),
                            ),
                          ),
                          Checkbox(
                            value: multiSelectionValue[
                                newDropDownList[index].originalIndex],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  multiSelectionValue[newDropDownList[index]
                                      .originalIndex] = value;
                                });
                              }
                            },
                            tristate:
                                widget.checkBoxProperty?.tristate ?? false,
                            mouseCursor: widget.checkBoxProperty?.mouseCursor,
                            activeColor: widget.checkBoxProperty?.activeColor,
                            fillColor: widget.checkBoxProperty?.fillColor,
                            checkColor: widget.checkBoxProperty?.checkColor,
                            focusColor: widget.checkBoxProperty?.focusColor,
                            hoverColor: widget.checkBoxProperty?.hoverColor,
                            overlayColor: widget.checkBoxProperty?.overlayColor,
                            splashRadius: widget.checkBoxProperty?.splashRadius,
                            materialTapTargetSize:
                                widget.checkBoxProperty?.materialTapTargetSize,
                            visualDensity:
                                widget.checkBoxProperty?.visualDensity,
                            focusNode: widget.checkBoxProperty?.focusNode,
                            autofocus:
                                widget.checkBoxProperty?.autofocus ?? false,
                            shape: widget.checkBoxProperty?.shape,
                            side: widget.checkBoxProperty?.side,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
        Row(
          children: [
            const Expanded(
              child: SizedBox.shrink(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 8.0, left: 8.0, top: 15, bottom: 10),
              child: InkWell(
                onTap: () => widget.onChanged(multiSelectionValue),
                child: Container(
                  height: widget.listTileHeight * 0.9,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12),
                  decoration: BoxDecoration(
                      color: widget.buttonColor ?? Colors.green,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                  child: Align(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding:
                            widget.buttonPadding ?? const EdgeInsets.all(8.0),
                        child: Text(
                          widget.buttonText ?? "Ok",
                          style: widget.buttonTextStyle ??
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
