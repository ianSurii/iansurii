import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md;

class MarkdownViewerApp extends StatefulWidget {
  final String filePath;

  const MarkdownViewerApp({super.key, required this.filePath});

  @override
  State<MarkdownViewerApp> createState() => _MarkdownViewerAppState();
}

class _MarkdownViewerAppState extends State<MarkdownViewerApp> {
  String _markdownContent = '';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMarkdownFile();
  }

  Future<void> _loadMarkdownFile() async {
    try {
      debugPrint('Attempting to load markdown from: ${widget.filePath}');
      final content = await rootBundle.loadString(widget.filePath);
      debugPrint('Successfully loaded ${content.length} characters');

      if (mounted) {
        setState(() {
          _markdownContent = content;
          _isLoading = false;
          _errorMessage = null;
        });
        debugPrint(
          'Markdown content set, first 100 chars: ${content.substring(0, content.length > 100 ? 100 : content.length)}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error loading markdown file: $e');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading markdown file...'),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Failed to load markdown file',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'File: ${widget.filePath}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Error: $_errorMessage',
                style: const TextStyle(fontSize: 12, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Markdown(
        data: _markdownContent,
        selectable: true,
        extensionSet: md.ExtensionSet.gitHubFlavored,
        imageBuilder: (uri, title, alt) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 30, maxWidth: 30),
              child: Image.network(
                uri.toString(),
                height: 24,
                width: 24,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    width: 24,
                    height: 24,
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 16,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 1.5),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
        onTapLink: (text, href, title) {
          if (href != null) {
            launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
          }
        },
        styleSheet: MarkdownStyleSheet(
          h1: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          h2: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          h3: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          p: const TextStyle(fontSize: 13, height: 1.3, color: Colors.black87),
          a: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          code: TextStyle(
            backgroundColor: Colors.grey[200],
            fontFamily: 'monospace',
            color: Colors.black,
          ),
          codeblockDecoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          blockquote: const TextStyle(
            color: Colors.black54,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
