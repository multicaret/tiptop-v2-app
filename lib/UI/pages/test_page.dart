// Copyright 2019 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const numberOfItems = 50;
const minItemHeight = 20.0;
const maxItemHeight = 150.0;
const scrollDuration = Duration(seconds: 2);

const randomMax = 1 << 32;

/// Example widget that uses [ScrollablePositionedList].
///
/// Shows a [ScrollablePositionedList] along with the following controls:
///   - Buttons to jump or scroll to certain items in the list.
///   - Slider to control the alignment of the items being scrolled or jumped
///   to.
///   - A checkbox to reverse the list.
///
/// If the device this example is being used on is in portrait mode, the list
/// will be vertically scrollable, and if the device is in landscape mode, the
/// list will be horizontally scrollable.
class TestPage extends StatefulWidget {
  const TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  /// Controller to scroll or jump to a particular item.
  final ItemScrollController itemScrollController = ItemScrollController();

  /// Listener that reports the position of items when the list is scrolled.
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  List<double> itemHeights;
  List<Color> itemColors;
  bool reversed = false;

  /// The alignment to be used next time the user scrolls or jumps to an item.
  double alignment = 0;

  @override
  void initState() {
    super.initState();
    final heightGenerator = Random(328902348);
    final colorGenerator = Random(42490823);
    itemHeights = List<double>.generate(numberOfItems, (int _) => heightGenerator.nextDouble() * (maxItemHeight - minItemHeight) + minItemHeight);
    itemColors = List<Color>.generate(numberOfItems, (int _) => Color(colorGenerator.nextInt(randomMax)).withOpacity(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    key: ValueKey<String>('Scroll5'),
                    onPressed: () => scrollTo(5),
                    child: Text('5'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    key: ValueKey<String>('Scroll50'),
                    onPressed: () => scrollTo(50),
                    child: Text('50'),
                  ),
                ),
              ],
            ),
            ValueListenableBuilder<Iterable<ItemPosition>>(
              valueListenable: itemPositionsListener.itemPositions,
              builder: (context, positions, child) {
                int min;
                if (positions.isNotEmpty) {
                  // Determine the first visible item by finding the item with the
                  // smallest trailing edge that is greater than 0.  i.e. the first
                  // item whose trailing edge in visible in the viewport.
                  min = positions
                      .where((ItemPosition position) => position.itemTrailingEdge > 0)
                      .reduce((ItemPosition min, ItemPosition position) => position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
                      .index;
                }
                return Row(
                  children: <Widget>[
                    Expanded(child: Text('First Item: ${min ?? ''}')),
                  ],
                );
              },
            ),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemCount: numberOfItems,
                itemBuilder: (context, index) => item(index),
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                reverse: reversed,
                scrollDirection: Axis.vertical,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get alignmentControl => Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Text('Alignment: '),
          SizedBox(
            width: 200,
            child: SliderTheme(
              data: SliderThemeData(
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: Slider(
                value: alignment,
                label: alignment.toStringAsFixed(2),
                onChanged: (double value) => setState(() => alignment = value),
              ),
            ),
          ),
        ],
      );

  void scrollTo(int index) =>
      itemScrollController.scrollTo(index: index, duration: scrollDuration, curve: Curves.easeInOutCubic, alignment: alignment);

  void jumpTo(int index) => itemScrollController.jumpTo(index: index, alignment: alignment);

  /// Generate item number [i].
  Widget item(int i) {
    return SizedBox(
      height: itemHeights[i],
      child: Container(
        color: itemColors[i],
        child: Center(
          child: Text('Item $i'),
        ),
      ),
    );
  }
}
