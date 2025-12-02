import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui_web' as ui_web;
import 'dart:html' as html;

class BrowserTab {
  final String id;
  String url;
  String title;
  WebViewController? controller;
  bool isLoading;

  BrowserTab({
    required this.id,
    required this.url,
    this.title = 'New Tab',
    this.controller,
    this.isLoading = true,
  });
}

class BrowserApp extends StatefulWidget {
  final String? initialUrl;

  const BrowserApp({super.key, this.initialUrl});

  @override
  State<BrowserApp> createState() => _BrowserAppState();
}

class _BrowserAppState extends State<BrowserApp> {
  final List<BrowserTab> _tabs = [];
  int _currentTabIndex = 0;
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initialUrl =
        widget.initialUrl ??
        'https://www.linkedin.com/in/muthuri-ian-a6b306151/';
    _addNewTab(initialUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _addNewTab([String? url]) {
    final newUrl = url ?? 'https://duckduckgo.com';
    final tab = BrowserTab(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: newUrl,
    );

    if (!kIsWeb) {
      tab.controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              setState(() {
                tab.isLoading = true;
                tab.url = url;
              });
            },
            onPageFinished: (url) {
              setState(() {
                tab.isLoading = false;
              });
              tab.controller?.getTitle().then((title) {
                if (title != null) {
                  setState(() => tab.title = title);
                }
              });
            },
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(newUrl));
    }

    setState(() {
      _tabs.add(tab);
      _currentTabIndex = _tabs.length - 1;
      _urlController.text = newUrl;
    });
  }

  void _closeTab(int index) {
    if (_tabs.length == 1) return; // Keep at least one tab
    setState(() {
      _tabs.removeAt(index);
      if (_currentTabIndex >= _tabs.length) {
        _currentTabIndex = _tabs.length - 1;
      }
      _urlController.text = _tabs[_currentTabIndex].url;
    });
  }

  void _switchTab(int index) {
    setState(() {
      _currentTabIndex = index;
      _urlController.text = _tabs[index].url;
    });
  }

  void _navigateToUrl(String input) {
    String url;
    // Check if it's a URL or search query
    if (input.startsWith('http://') || input.startsWith('https://')) {
      url = input;
    } else if (input.contains('.') && !input.contains(' ')) {
      // Looks like a domain
      url = 'https://$input';
    } else {
      // Search query - use DuckDuckGo
      url = 'https://duckduckgo.com/?q=${Uri.encodeComponent(input)}';
    }

    if (kIsWeb) {
      // On web, open in new tab
      _addNewTab(url);
    } else {
      final currentTab = _tabs[_currentTabIndex];
      currentTab.controller?.loadRequest(Uri.parse(url));
      setState(() {
        currentTab.url = url;
        _urlController.text = url;
      });
    }
  }

  Future<void> _launchInBrowser() async {
    final uri = Uri.parse(_tabs[_currentTabIndex].url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_tabs.isEmpty) return const SizedBox.shrink();

    final currentTab = _tabs[_currentTabIndex];

    // Register iframe for web platform
    if (kIsWeb && currentTab.controller == null) {
      final iframeId = 'iframe-${currentTab.id}';
      // Register the view factory only once per tab
      try {
        ui_web.platformViewRegistry.registerViewFactory(iframeId, (int viewId) {
          final iframe = html.IFrameElement()
            ..src = currentTab.url
            ..style.border = 'none'
            ..style.height = '100%'
            ..style.width = '100%';
          return iframe;
        });
      } catch (e) {
        // View already registered
      }
    }

    return Column(
      children: [
        // Firefox-like header with tabs
        Container(
          color: const Color(0xFF4A4A4F),
          child: Column(
            children: [
              // Tab bar
              Container(
                height: 36,
                color: const Color(0xFF38383D),
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _tabs.length,
                        itemBuilder: (context, index) {
                          final tab = _tabs[index];
                          final isActive = index == _currentTabIndex;
                          return GestureDetector(
                            onTap: () => _switchTab(index),
                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 150,
                                maxWidth: 250,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFF4A4A4F)
                                    : const Color(0xFF38383D),
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  if (tab.isLoading)
                                    const SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white70,
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.public,
                                      size: 14,
                                      color: Colors.white70,
                                    ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      tab.title,
                                      style: TextStyle(
                                        color: isActive
                                            ? Colors.white
                                            : Colors.white70,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 14),
                                    color: Colors.white70,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => _closeTab(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      color: Colors.white70,
                      onPressed: () => _addNewTab(),
                    ),
                  ],
                ),
              ),
              // Address bar
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 20),
                      color: Colors.white70,
                      onPressed: () async {
                        if (await currentTab.controller?.canGoBack() ?? false) {
                          currentTab.controller?.goBack();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward, size: 20),
                      color: Colors.white70,
                      onPressed: () async {
                        if (await currentTab.controller?.canGoForward() ??
                            false) {
                          currentTab.controller?.goForward();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        currentTab.isLoading ? Icons.close : Icons.refresh,
                        size: 20,
                      ),
                      color: Colors.white70,
                      onPressed: () {
                        if (currentTab.isLoading) {
                          currentTab.controller?.loadRequest(
                            Uri.parse('about:blank'),
                          );
                        } else {
                          currentTab.controller?.reload();
                        }
                      },
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF38383D),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextField(
                          controller: _urlController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search or enter address',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              size: 16,
                              color: Colors.white70,
                            ),
                          ),
                          onSubmitted: _navigateToUrl,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Web content
        Expanded(
          child: Stack(
            children: [
              if (kIsWeb)
                HtmlElementView(viewType: 'iframe-${currentTab.id}')
              else if (currentTab.controller != null)
                WebViewWidget(controller: currentTab.controller!),
              if (currentTab.isLoading && !kIsWeb)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ],
    );
  }
}
