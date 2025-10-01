import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'tarefa.dart';

class GerenciadorTarefas {
  List<Tarefa> _tarefas = [];
  static const String _chaveTarefas = 'tarefas_salvas';

  // Getter para acessar a lista de tarefas
  List<Tarefa> get tarefas => List.unmodifiable(_tarefas);

  // Adicionar nova tarefa
  void adicionarTarefa(Tarefa tarefa) {
    _tarefas.add(tarefa);
    _salvarTarefas();
  }

  // Adicionar tarefa com parâmetros
  void adicionarNovaTarefa(String titulo, String descricao) {
    final tarefa = Tarefa.nova(titulo: titulo, descricao: descricao);
    adicionarTarefa(tarefa);
  }

  // Remover tarefa por ID
  void removerTarefa(int id) {
    _tarefas.removeWhere((tarefa) => tarefa.id == id);
    _salvarTarefas();
  }

  // Marcar tarefa como concluída
  void marcarConcluida(int id) {
    final tarefa = _tarefas.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Tarefa não encontrada'),
    );
    tarefa.marcarConcluida();
    _salvarTarefas();
  }

  // Marcar tarefa como pendente
  void marcarPendente(int id) {
    final tarefa = _tarefas.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Tarefa não encontrada'),
    );
    tarefa.marcarPendente();
    _salvarTarefas();
  }

  // Alternar status da tarefa
  void alternarStatus(int id) {
    final tarefa = _tarefas.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Tarefa não encontrada'),
    );
    tarefa.alternarStatus();
    _salvarTarefas();
  }

  // Editar tarefa existente
  void editarTarefa(int id, {String? novoTitulo, String? novaDescricao}) {
    final tarefa = _tarefas.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Tarefa não encontrada'),
    );
    tarefa.editar(novoTitulo: novoTitulo, novaDescricao: novaDescricao);
    _salvarTarefas();
  }

  // Obter tarefas por status
  List<Tarefa> obterTarefasPorStatus(bool? concluida) {
    if (concluida == null) {
      return List.unmodifiable(_tarefas);
    }
    return _tarefas.where((tarefa) => tarefa.concluida == concluida).toList();
  }

  // Obter todas as tarefas
  List<Tarefa> obterTodasTarefas() {
    return List.unmodifiable(_tarefas);
  }

  // Obter tarefas pendentes
  List<Tarefa> obterTarefasPendentes() {
    return obterTarefasPorStatus(false);
  }

  // Obter tarefas concluídas
  List<Tarefa> obterTarefasConcluidas() {
    return obterTarefasPorStatus(true);
  }

  // Buscar tarefa por ID
  Tarefa? buscarTarefaPorId(int id) {
    try {
      return _tarefas.firstWhere((tarefa) => tarefa.id == id);
    } catch (e) {
      return null;
    }
  }

  // Buscar tarefas por título
  List<Tarefa> buscarTarefasPorTitulo(String titulo) {
    return _tarefas
        .where((tarefa) => tarefa.titulo.toLowerCase().contains(titulo.toLowerCase()))
        .toList();
  }

  // Contar tarefas por status
  int contarTarefasPorStatus(bool? concluida) {
    if (concluida == null) {
      return _tarefas.length;
    }
    return _tarefas.where((tarefa) => tarefa.concluida == concluida).length;
  }

  // Limpar todas as tarefas
  void limparTodasTarefas() {
    _tarefas.clear();
    _salvarTarefas();
  }

  // Remover tarefas concluídas
  void removerTarefasConcluidas() {
    _tarefas.removeWhere((tarefa) => tarefa.concluida);
    _salvarTarefas();
  }

  // Salvar tarefas no SharedPreferences
  Future<void> _salvarTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    final tarefasJson = _tarefas.map((tarefa) => tarefa.toMap()).toList();
    await prefs.setString(_chaveTarefas, jsonEncode(tarefasJson));
  }

  // Carregar tarefas do SharedPreferences
  Future<void> carregarTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    final tarefasJson = prefs.getString(_chaveTarefas);
    
    if (tarefasJson != null) {
      final List<dynamic> tarefasList = jsonDecode(tarefasJson);
      _tarefas = tarefasList
          .map((tarefaMap) => Tarefa.fromMap(tarefaMap))
          .toList();
    }
  }

  // Obter estatísticas das tarefas
  Map<String, int> obterEstatisticas() {
    return {
      'total': _tarefas.length,
      'pendentes': contarTarefasPorStatus(false),
      'concluidas': contarTarefasPorStatus(true),
    };
  }

  // Ordenar tarefas por data de criação
  void ordenarPorDataCriacao({bool crescente = true}) {
    _tarefas.sort((a, b) {
      if (crescente) {
        return a.dataCriacao.compareTo(b.dataCriacao);
      } else {
        return b.dataCriacao.compareTo(a.dataCriacao);
      }
    });
  }

  // Ordenar tarefas por título
  void ordenarPorTitulo({bool crescente = true}) {
    _tarefas.sort((a, b) {
      if (crescente) {
        return a.titulo.compareTo(b.titulo);
      } else {
        return b.titulo.compareTo(a.titulo);
      }
    });
  }
}
