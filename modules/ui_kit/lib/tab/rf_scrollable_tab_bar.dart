import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/index.dart';
import 'package:ui_kit/tab/rf_tab.dart';

typedef OnValueChanged<T> = void Function(T value);

class RfScrollableTabBar<T> extends StatefulWidget {
  const RfScrollableTabBar({
    super.key,
    this.scrollPadding = 0,
    required this.onValueChanged,
    required this.tabs,
    this.selectedValue,
    this.backgroundColor,
    this.tabContentPadding = const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
  });

  final List<RfTab<T>> tabs;
  final double scrollPadding;
  final OnValueChanged<T> onValueChanged;
  final Color? backgroundColor;
  final EdgeInsets tabContentPadding;
  final T? selectedValue;

  @override
  State createState() => _RfScrollableTabBarState<T>();
}

class _RfScrollableTabBarState<T> extends State<RfScrollableTabBar<T>> {
  late bool isScrollable;
  late List<double> tabWidths;
  late double totalTabsWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkNeedScrollable();
  }

  void _checkNeedScrollable() {
    tabWidths = widget.tabs
        .map((tab) => _calculateTextWidth(
              tab.title,
              TextStyle()
            ))
        .toList();
    totalTabsWidth = tabWidths.reduce((a, b) => a + b) + (widget.scrollPadding * 2);
    final double screenWidth = MediaQuery.sizeOf(context).width;
    isScrollable = totalTabsWidth > screenWidth;
  }

  double _calculateTextWidth(String text, TextStyle style) {
    final horizontalPadding = widget.tabContentPadding.horizontal;
    final horizontalAdding = horizontalPadding * 2;

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return textPainter.width + horizontalAdding;
  }

  @override
  Widget build(BuildContext context) {
    if (isScrollable) {
      return _ScrollableTabBar<T>(
        tabs: widget.tabs,
        selectedValue: widget.selectedValue,
        onValueChanged: widget.onValueChanged,
        scrollPadding: widget.scrollPadding,
        backgroundColor: widget.backgroundColor,
        tabContentPadding: widget.tabContentPadding,
      );
    } else {
      return _NotScrollableTabBar<T>(
        tabs: widget.tabs,
        selectedValue: widget.selectedValue,
        onValueChanged: widget.onValueChanged,
        scrollPadding: widget.scrollPadding,
        totalTabsWidth: totalTabsWidth,
        tabsWidth: tabWidths,
        backgroundColor: widget.backgroundColor,
        tabContentPadding: widget.tabContentPadding,
      );
    }
  }
}

class _NotScrollableTabBar<T> extends StatefulWidget {
  const  _NotScrollableTabBar({
    super.key,
    required this.tabs,
    required this.scrollPadding,
    required this.onValueChanged,
    required this.totalTabsWidth,
    required this.tabsWidth,
    required this.backgroundColor,
    required this.tabContentPadding,
    this.selectedValue,
  });

  final List<RfTab<T>> tabs;
  final List<double> tabsWidth;
  final double totalTabsWidth;
  final double scrollPadding;
  final OnValueChanged<T> onValueChanged;
  final Color? backgroundColor;
  final EdgeInsets tabContentPadding;
  final T? selectedValue;

  @override
  State<_NotScrollableTabBar> createState() => _NotScrollableTabBarState<T>();
}

class _NotScrollableTabBarState<T> extends State<_NotScrollableTabBar<T>> {
  late bool _isTabEquals = true;
  int _selectedIndex = 0;
  List<double> _tabsWidth = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = _findSelectedValue();
    _tabsWidth = widget.tabsWidth;
  }

  int _findSelectedValue() {
    for (int i = 0; i < widget.tabs.length; i++) {
      final tab = widget.tabs[i];
      if (tab.value == widget.selectedValue) {
        return i;
      }
    }
    return 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkTabsAreEqualsAndRecalculateWidths();
  }

  void _checkTabsAreEqualsAndRecalculateWidths() {
    _tabsWidth = widget.tabsWidth;
    final availableScreenWidth = MediaQuery.sizeOf(context).width - widget.scrollPadding * 2;
    final equalTabSize = availableScreenWidth / widget.tabs.length;
    for (var element in _tabsWidth) {
      if (element > equalTabSize) {
        _isTabEquals = false;
        break;
      }
    }
    if (!_isTabEquals) {
      _recalculateTabWidth(availableScreenWidth);
    }
  }

  void _recalculateTabWidth(double availableSize) {
    final totalTabsWidth = _tabsWidth.reduce((a, b) => a + b) + (widget.scrollPadding * 2);
    final restSpace = availableSize - totalTabsWidth;
    if (restSpace < 0) {
      final maxTabWidth = _tabsWidth.max;
      final deviations = _tabsWidth.map((e) => e - maxTabWidth).toList();
      final deviationsSum = deviations.reduce((a, b) => a + b);
      final deviationWeight = restSpace / deviationsSum;
      _tabsWidth = _tabsWidth.map((e) {
        return (e - maxTabWidth) * deviationWeight + e;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final colors = context.theme.colors;
    final tabs = widget.tabs.mapIndexed((index, RfTab<T> tab) {
      bool isSelected = index == _selectedIndex;
      final EdgeInsets margin;
      if (index == 0) {
        margin = const EdgeInsets.only(left: 4, top: 4, bottom: 4);
      } else if (index == widget.tabs.length - 1) {
        margin = const EdgeInsets.only(right: 4, top: 4, bottom: 4);
      } else {
        margin = const EdgeInsets.symmetric(vertical: 4);
      }
      return Flexible(
        flex: _isTabEquals ? 1 : (_tabsWidth[index] * 100 / widget.totalTabsWidth).toInt(),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
            widget.onValueChanged(tab.value);
          },
          child: Container(
            margin: margin,
            padding: widget.tabContentPadding,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              tab.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: context.rfTextTheme().smallTitle.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.scrollPadding),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0x10000000),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: tabs,
          ),
        ],
      ),
    );
  }
}

class _ScrollableTabBar<T> extends StatefulWidget {
  const _ScrollableTabBar({
    super.key,
    this.scrollPadding = 0,
    required this.onValueChanged,
    required this.tabs,
    required this.backgroundColor,
    required this.tabContentPadding,
    this.selectedValue,
  });

  final List<RfTab<T>> tabs;
  final double scrollPadding;
  final OnValueChanged<T> onValueChanged;
  final Color? backgroundColor;
  final EdgeInsets tabContentPadding;
  final T? selectedValue;

  @override
  State<_ScrollableTabBar> createState() => _ScrollableTabBarState<T>();
}

class _ScrollableTabBarState<T> extends State<_ScrollableTabBar<T>> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;

  final List<GlobalKey> _tabKeys = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = _findSelectedValue();
    _tabKeys.addAll(List.generate(widget.tabs.length, (_) => GlobalKey()));
  }

  int _findSelectedValue() {
    for (int i = 0; i < widget.tabs.length; i++) {
      final tab = widget.tabs[i];
      if (tab.value == widget.selectedValue) {
        return i;
      }
    }
    return 0;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final colors = context.theme.colors;
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0x10000000),
                borderRadius: BorderRadius.circular(4),
              ),
              margin: EdgeInsets.symmetric(horizontal: widget.scrollPadding),
            ),
          ),
          Row(
            children: [
              SizedBox(width: widget.scrollPadding), // Пустое пространство слева
              ...widget.tabs.mapIndexed((index, RfTab<T> tab) {
                bool isSelected = index == _selectedIndex;
                final EdgeInsets margin;
                if (index == 0) {
                  margin = const EdgeInsets.only(left: 2, top: 4, bottom: 4);
                } else if (index == widget.tabs.length - 1) {
                  margin = const EdgeInsets.only(right: 2, top: 4, bottom: 4);
                } else {
                  margin = const EdgeInsets.symmetric(vertical: 4);
                }

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    widget.onValueChanged(tab.value);
                    _scrollToSelected();
                  },
                  child: Container(
                    key: _tabKeys[index],
                    margin: margin,
                    padding: widget.tabContentPadding,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      tab.title,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: context.rfTextTheme().smallTitle.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(width: widget.scrollPadding),
            ],
          ),
        ],
      ),
    );
  }

  void _scrollToSelected() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      // Get `RenderBox` for the selected tab
      final selectedTabBox =
          _tabKeys[_selectedIndex].currentContext?.findRenderObject() as RenderBox?;
      final scrollViewBox =
          _scrollController.position.context.storageContext.findRenderObject() as RenderBox?;

      if (selectedTabBox == null || scrollViewBox == null) return;

      // Coordinates of the selected tab relative to `ScrollView`
      final tabOffset = selectedTabBox.localToGlobal(Offset.zero, ancestor: scrollViewBox).dx;

      // Current scroll position
      final currentScrollOffset = _scrollController.offset;

      final screenWidth = MediaQuery.of(context).size.width;

      // Offset so that the tab is centered
      final targetOffset =
          currentScrollOffset + tabOffset - (screenWidth / 2) + (selectedTabBox.size.width / 2);

      _scrollController.animateTo(
        targetOffset.clamp(
          _scrollController.position.minScrollExtent,
          _scrollController.position.maxScrollExtent,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
}
