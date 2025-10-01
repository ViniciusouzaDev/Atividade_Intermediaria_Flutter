import 'package:flutter/material.dart';
import 'tarefa.dart';
import 'gerenciador_tarefas.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListaTarefasScreen(),
    );
  }
}

class ListaTarefasScreen extends StatefulWidget {
  @override
  _ListaTarefasScreenState createState() => _ListaTarefasScreenState();
}

class _ListaTarefasScreenState extends State<ListaTarefasScreen> {
  final GerenciadorTarefas _gerenciador = GerenciadorTarefas();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  String _filtroAtual = 'todas'; // 'todas', 'pendentes', 'concluidas'
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    await _gerenciador.carregarTarefas();
    setState(() {
      _carregando = false;
    });
  }

  List<Tarefa> _obterTarefasFiltradas() {
    switch (_filtroAtual) {
      case 'pendentes':
        return _gerenciador.obterTarefasPendentes();
      case 'concluidas':
        return _gerenciador.obterTarefasConcluidas();
      default:
        return _gerenciador.obterTodasTarefas();
    }
  }

  void _adicionarTarefa() {
    if (_tituloController.text.trim().isEmpty) {
      _mostrarMensagem('Por favor, digite um título para a tarefa.');
      return;
    }

    _gerenciador.adicionarNovaTarefa(
      _tituloController.text.trim(),
      _descricaoController.text.trim(),
    );

    _tituloController.clear();
    _descricaoController.clear();
    setState(() {});
    _mostrarMensagem('Tarefa adicionada com sucesso!');
  }

  void _mostrarDialogoAdicionar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nova Tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _tituloController.clear();
                _descricaoController.clear();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _adicionarTarefa();
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoEditar(Tarefa tarefa) {
    final tituloController = TextEditingController(text: tarefa.titulo);
    final descricaoController = TextEditingController(text: tarefa.descricao);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _gerenciador.editarTarefa(
                  tarefa.id,
                  novoTitulo: tituloController.text.trim(),
                  novaDescricao: descricaoController.text.trim(),
                );
                Navigator.of(context).pop();
                setState(() {});
                _mostrarMensagem('Tarefa editada com sucesso!');
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmarExclusao(Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir a tarefa "${tarefa.titulo}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _gerenciador.removerTarefa(tarefa.id);
                Navigator.of(context).pop();
                setState(() {});
                _mostrarMensagem('Tarefa excluída com sucesso!');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Widget _construirItemTarefa(Tarefa tarefa) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: tarefa.concluida,
          onChanged: (bool? value) {
            _gerenciador.alternarStatus(tarefa.id);
            setState(() {});
          },
        ),
        title: Text(
          tarefa.titulo,
          style: TextStyle(
            decoration: tarefa.concluida ? TextDecoration.lineThrough : null,
            color: tarefa.concluida ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tarefa.descricao.isNotEmpty)
              Text(
                tarefa.descricao,
                style: TextStyle(
                  color: tarefa.concluida ? Colors.grey : null,
                ),
              ),
            SizedBox(height: 4),
            Text(
              'Criada em: ${_formatarData(tarefa.dataCriacao)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (String value) {
            switch (value) {
              case 'editar':
                _mostrarDialogoEditar(tarefa);
                break;
              case 'excluir':
                _confirmarExclusao(tarefa);
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'editar',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'excluir',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Excluir', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day}/${data.month}/${data.year} ${data.hour}:${data.minute.toString().padLeft(2, '0')}';
  }

  Widget _construirFiltros() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'todas', label: Text('Todas')),
                ButtonSegment(value: 'pendentes', label: Text('Pendentes')),
                ButtonSegment(value: 'concluidas', label: Text('Concluídas')),
              ],
              selected: {_filtroAtual},
              onSelectionChanged: (Set<String> selection) {
                setState(() {
                  _filtroAtual = selection.first;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirEstatisticas() {
    final stats = _gerenciador.obterEstatisticas();
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _construirStatCard('Total', stats['total']!, Colors.blue),
          _construirStatCard('Pendentes', stats['pendentes']!, Colors.orange),
          _construirStatCard('Concluídas', stats['concluidas']!, Colors.green),
        ],
      ),
    );
  }

  Widget _construirStatCard(String titulo, int valor, Color cor) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            valor.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 12,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final tarefasFiltradas = _obterTarefasFiltradas();

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _construirEstatisticas(),
          _construirFiltros(),
          Expanded(
            child: tarefasFiltradas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          _filtroAtual == 'todas'
                              ? 'Nenhuma tarefa encontrada'
                              : 'Nenhuma tarefa ${_filtroAtual} encontrada',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: tarefasFiltradas.length,
                    itemBuilder: (context, index) {
                      return _construirItemTarefa(tarefasFiltradas[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Limpar Tarefas Concluídas'),
                    content: Text('Deseja remover todas as tarefas concluídas?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _gerenciador.removerTarefasConcluidas();
                          Navigator.pop(context);
                          setState(() {});
                          _mostrarMensagem('Tarefas concluídas removidas!');
                        },
                        child: Text('Remover'),
                      ),
                    ],
                  ),
                );
              },
              child: Icon(Icons.delete_sweep),
              backgroundColor: Colors.red,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: FloatingActionButton(
              onPressed: _mostrarDialogoAdicionar,
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

