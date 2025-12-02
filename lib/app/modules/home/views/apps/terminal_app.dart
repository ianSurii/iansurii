import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

class TerminalApp extends StatefulWidget {
  const TerminalApp({super.key});

  @override
  State<TerminalApp> createState() => _TerminalAppState();
}

class _TerminalAppState extends State<TerminalApp> {
  late final Terminal _terminal;
  late final TerminalController _terminalController;
  String _currentLine = '';

  @override
  void initState() {
    super.initState();
    _terminal = Terminal(maxLines: 10000);
    _terminalController = TerminalController();

    // Listen to user output/input
    _terminal.onOutput = (output) {
      // Handle command input
      if (output.contains('\r') || output.contains('\n')) {
        _handleCommand(_currentLine);
        _currentLine = '';
      } else if (output == '\x7f' || output == '\b') {
        // Handle backspace
        if (_currentLine.isNotEmpty) {
          _currentLine = _currentLine.substring(0, _currentLine.length - 1);
          _terminal.write('\b \b'); // Erase the character visually
        }
      } else {
        // Regular character input - echo it back and store it
        _terminal.write(output);
        _currentLine += output;
      }
    };

    // Initialize with welcome message
    _terminal.write('Welcome to Ubuntu Terminal\r\n');
    _terminal.write('Type "help" for available commands\r\n\r\n');
    _terminal.write('iansurii@local:~\$ ');
  }

  void _handleCommand(String input) {
    final command = input.trim();

    _terminal.write('\r\n');

    if (command.isEmpty) {
      _terminal.write('iansurii@local:~\$ ');
      return;
    }

    switch (command) {
      case 'clear':
        _terminal.buffer.clear();
        _terminal.write('iansurii@local:~\$ ');
        break;
      case 'help':
        _terminal.write(
          'Available commands: help, clear, date, whoami, pwd, ls, echo\r\n',
        );
        _terminal.write('iansurii@local:~\$ ');
        break;
      case 'date':
        _terminal.write('${DateTime.now()}\r\n');
        _terminal.write('iansurii@local:~\$ ');
        break;
      case 'whoami':
        _terminal.write('iansurii\r\n');
        _terminal.write('iansurii@local:~\$ ');
        break;
      case 'pwd':
        _terminal.write('/home/iansurii\r\n');
        _terminal.write('iansurii@local:~\$ ');
        break;
      case 'ls':
        _terminal.write('Documents  Downloads  Pictures  Desktop\r\n');
        _terminal.write('iansurii@local:~\$ ');
        break;
      default:
        // Handle echo command
        if (command.startsWith('echo ')) {
          final text = command.substring(5);
          _terminal.write('$text\r\n');
          _terminal.write('iansurii@local:~\$ ');
        } else {
          _terminal.write('$command: command not found\r\n');
          _terminal.write('iansurii@local:~\$ ');
        }
        break;
    }
  }

  @override
  void dispose() {
    _terminalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF300A24), // Ubuntu terminal purple
      child: TerminalView(
        _terminal,
        controller: _terminalController,
        autofocus: true,
        backgroundOpacity: 1.0,
        textStyle: const TerminalStyle(fontSize: 14, fontFamily: 'monospace'),
        theme: TerminalTheme(
          cursor: const Color(0xFFFFFFFF),
          selection: const Color(0xFF4D4D4D),
          foreground: const Color(0xFFFFFFFF),
          background: const Color(0xFF300A24),
          black: const Color(0xFF2E3436),
          red: const Color(0xFFCC0000),
          green: const Color(0xFF4E9A06),
          yellow: const Color(0xFFC4A000),
          blue: const Color(0xFF3465A4),
          magenta: const Color(0xFF75507B),
          cyan: const Color(0xFF06989A),
          white: const Color(0xFFD3D7CF),
          brightBlack: const Color(0xFF555753),
          brightRed: const Color(0xFFEF2929),
          brightGreen: const Color(0xFF8AE234),
          brightYellow: const Color(0xFFFCE94F),
          brightBlue: const Color(0xFF729FCF),
          brightMagenta: const Color(0xFFAD7FA8),
          brightCyan: const Color(0xFF34E2E2),
          brightWhite: const Color(0xFFEEEEEC),
          searchHitBackground: const Color(0xFFFCE94F),
          searchHitBackgroundCurrent: const Color(0xFFFFAA00),
          searchHitForeground: const Color(0xFF000000),
        ),
      ),
    );
  }
}
