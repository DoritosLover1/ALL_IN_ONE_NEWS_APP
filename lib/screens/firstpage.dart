import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medic/constants/universaltheme.dart';
import 'package:flutter_medic/controllers/source_selection_controller.dart';
import 'package:flutter_medic/screens/sync_loading_screen.dart';
import 'package:flutter_medic/services/user_preferences_service.dart';
import 'package:flutter_medic/widgets/confirmation_dialog.dart';
import 'package:flutter_medic/widgets/custom_search_bar.dart';
import 'package:flutter_medic/widgets/floating_bottom_button.dart';
import 'package:flutter_medic/widgets/selectable_card.dart';
import 'package:flutter_medic/widgets/selection_bar.dart';
import 'package:provider/provider.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  final SourceSelectionController _controller = SourceSelectionController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onContinuePressed() async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: "Seçimleri Onayla",
      count: _controller.selectedCount,
      content: "Haber akışınız ve bildirimleriniz seçtiğiniz bu kaynaklara göre kişiselleştirilecektir. Devam etmek istiyor musunuz?",
      confirmText: "Evet, Devam Et",
      cancelText: "Vazgeç",
    );

    if (confirmed == true && mounted) {
      await UserPreferencesService.saveSelectedSources(_controller.selectedIds);
      await UserPreferencesService.setOnboardingCompleted(true);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              SyncLoadingScreen(selectedSourceIds: _controller.selectedIds),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            themeProvider.themeData.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
    );

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final filteredSources = _controller.filteredSources;

        return Scaffold(
          extendBody: true,
          backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            elevation: 0,
            leadingWidth: 72,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Center(
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.newspaper_rounded,
                    size: 26.0,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SENİN HABERLERİN",
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Senin istediklerin tam burada",
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hangi kaynakları",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "takip edelim?",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Seçtiğin kanallara göre haber akışını ve canlı yayınları senin için kişiselleştirelim.",
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SelectionBar(
                        selectedCount: _controller.selectedCount,
                        onSelectAll: _controller.selectAll,
                        onClearAll: _controller.clearAll,
                      ),
                      const SizedBox(height: 12),
                      CustomSearchBar(
                        controller: _searchController,
                        onChanged: _controller.setSearchQuery,
                        onClear: _controller.clearSearch,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Expanded(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overscroll) {
                      overscroll.disallowIndicator();
                      return true;
                    },
                    child: GridView.builder(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 110),
                      itemCount: filteredSources.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.85,
                          ),
                      itemBuilder: (context, index) {
                        final item = filteredSources[index];
                        return SelectableCard(
                          item: item,
                          isSelected: _controller.isSelected(item.id),
                          onTap: () => _controller.toggleItem(item.id),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingBottomButton(
            text: "Devam Et (${_controller.selectedCount})",
            isEnabled: _controller.hasSelection,
            onPressed: _onContinuePressed,
          ),
        );
      },
    );
  }
}
