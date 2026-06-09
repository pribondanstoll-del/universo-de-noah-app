import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControleTernoScreen extends StatefulWidget {
  const ControleTernoScreen({super.key});

  @override
  State<ControleTernoScreen> createState() => _ControleTernoScreenState();
}

class _ControleTernoScreenState extends State<ControleTernoScreen> {
  bool _limiteAtivo = false;
  int _limiteMins = 30;
  bool _horarioAtivo = false;
  TimeOfDay _horarioInicio = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _horarioFim = const TimeOfDay(hour: 20, minute: 0);
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarConfigs();
  }

  Future<void> _carregarConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _limiteAtivo = prefs.getBool('limite_ativo') ?? false;
      _limiteMins = prefs.getInt('limite_mins') ?? 30;
      _horarioAtivo = prefs.getBool('horario_ativo') ?? false;
      _horarioInicio = TimeOfDay(
        hour: prefs.getInt('horario_inicio_h') ?? 8,
        minute: prefs.getInt('horario_inicio_m') ?? 0,
      );
      _horarioFim = TimeOfDay(
        hour: prefs.getInt('horario_fim_h') ?? 20,
        minute: prefs.getInt('horario_fim_m') ?? 0,
      );
      _carregando = false;
    });
  }

  Future<void> _salvarConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('limite_ativo', _limiteAtivo);
    await prefs.setInt('limite_mins', _limiteMins);
    await prefs.setBool('horario_ativo', _horarioAtivo);
    await prefs.setInt('horario_inicio_h', _horarioInicio.hour);
    await prefs.setInt('horario_inicio_m', _horarioInicio.minute);
    await prefs.setInt('horario_fim_h', _horarioFim.hour);
    await prefs.setInt('horario_fim_m', _horarioFim.minute);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Configurações salvas!'),
          backgroundColor: Color(0xFF34A853),
        ),
      );
    }
  }

  Future<void> _selecionarHorario(bool isInicio) async {
    final horario = await showTimePicker(
      context: context,
      initialTime: isInicio ? _horarioInicio : _horarioFim,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1A73E8),
              surface: Color(0xFF1E2D5A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (horario != null) {
      setState(() {
        if (isInicio) {
          _horarioInicio = horario;
        } else {
          _horarioFim = horario;
        }
      });
    }
  }

  String _formatarHorario(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D1B4B),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF8BB4F8))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B4B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '⏱️ Controle de Tempo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A73E8).withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFF1A73E8).withOpacity(0.4)),
              ),
              child: const Row(
                children: [
                  Text('💡', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Configure quanto tempo por dia e em quais horários seu filho pode usar o app.',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Limite diário
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2D5A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('⏱️ Limite diário',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text('Tempo máximo por dia',
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                      Switch(
                        value: _limiteAtivo,
                        activeColor: const Color(0xFF1A73E8),
                        onChanged: (v) => setState(() => _limiteAtivo = v),
                      ),
                    ],
                  ),
                  if (_limiteAtivo) ...[
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        '$_limiteMins min',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Slider(
                      value: _limiteMins.toDouble(),
                      min: 10,
                      max: 120,
                      divisions: 11,
                      activeColor: const Color(0xFF1A73E8),
                      inactiveColor: const Color(0xFF0D1B4B),
                      onChanged: (v) =>
                          setState(() => _limiteMins = v.round()),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('10 min',
                            style: TextStyle(
                                color: Colors.white38, fontSize: 12)),
                        const Text('120 min',
                            style: TextStyle(
                                color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF34A853).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFF34A853).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Text('✅',
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Text(
                            'Após $_limiteMins minutos, o app vai pausar e sugerir uma pausa.',
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Horário permitido
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2D5A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('🕐 Horário permitido',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text('Definir horário de uso',
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                      Switch(
                        value: _horarioAtivo,
                        activeColor: const Color(0xFF7B2FBE),
                        onChanged: (v) =>
                            setState(() => _horarioAtivo = v),
                      ),
                    ],
                  ),
                  if (_horarioAtivo) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selecionarHorario(true),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7B2FBE)
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: const Color(0xFF7B2FBE)
                                        .withOpacity(0.4)),
                              ),
                              child: Column(
                                children: [
                                  const Text('Início',
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatarHorario(_horarioInicio),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('até',
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 16)),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selecionarHorario(false),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7B2FBE)
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: const Color(0xFF7B2FBE)
                                        .withOpacity(0.4)),
                              ),
                              child: Column(
                                children: [
                                  const Text('Fim',
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatarHorario(_horarioFim),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B2FBE).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color:
                                const Color(0xFF7B2FBE).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Text('🕐',
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Fora do horário ${_formatarHorario(_horarioInicio)} — ${_formatarHorario(_horarioFim)}, o app mostrará uma mensagem de pausa.',
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Botão salvar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34A853),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _salvarConfigs,
                child: const Text(
                  'Salvar configurações ✅',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}