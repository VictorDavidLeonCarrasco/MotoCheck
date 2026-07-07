import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  static const Color _azulPrincipal = Color(0xFF1565C0);
  static const Color _azulOscuro = Color(0xFF0D47A1);

  late TextEditingController _searchController;
  String _selectedCategory = 'Todas';
  List<FAQItem> _filteredFAQs = [];

  final List<String> categories = [
    'Todas',
    'General',
    'Vehículos',
    'Mantenimiento',
    'Cuenta',
  ];

  final List<FAQItem> faqs = [
    FAQItem(
      category: 'General',
      question: '¿Qué es MotoCheck?',
      answer:
          'MotoCheck es una aplicación diseñada para gestionar flotas de mototaxis o taxis, permitiendo controlar vehículos, mantenimientos y usuarios desde un solo lugar.',
    ),
    FAQItem(
      category: 'General',
      question: '¿Cómo me registro en MotoCheck?',
      answer:
          'En la pantalla de inicio de sesión toca "Crear cuenta". Completa tus datos, verifica tu correo y accede con tu usuario y contraseña.',
    ),
    FAQItem(
      category: 'General',
      question: '¿Qué tipos de usuarios hay?',
      answer:
          'Hay usuarios propietarios, personal de taller y administradores de flota, cada uno con acceso distinto según sus funciones.',
    ),
    FAQItem(
      category: 'Vehículos',
      question: '¿Cómo agrego un nuevo vehículo?',
      answer:
          'Ve a la sección "Vehículos" y usa el botón "+" para registrar placa, marca, modelo, año y otros datos importantes.',
    ),
    FAQItem(
      category: 'Vehículos',
      question: '¿Puedo editar los datos de un vehículo?',
      answer:
          'Sí, selecciona el vehículo en la lista y usa la opción de editar para actualizar sus datos.',
    ),
    FAQItem(
      category: 'Vehículos',
      question: '¿Cómo elimino un vehículo?',
      answer:
          'Abre el perfil del vehículo, presiona el botón de eliminar y confirma la acción. Ten en cuenta que esto es irreversible.',
    ),
    FAQItem(
      category: 'Mantenimiento',
      question: '¿Cómo registro un mantenimiento?',
      answer:
          'Ingresa a la sección de taller, crea un nuevo registro y completa la información de servicio, fecha, costo y observaciones.',
    ),
    FAQItem(
      category: 'Mantenimiento',
      question: '¿Puedo revisar el historial de mantenimientos?',
      answer:
          'Sí, cada vehículo muestra su historial de mantenimientos con fechas, tipo de servicio y costos.',
    ),
    FAQItem(
      category: 'Mantenimiento',
      question: '¿Cómo activo recordatorios de mantenimiento?',
      answer:
          'Configura las fechas de mantenimiento para cada vehículo y MotoCheck te avisará cuando se acerque la fecha programada.',
    ),
    FAQItem(
      category: 'Cuenta',
      question: '¿Cómo cambio mi contraseña?',
      answer:
          'Ve a la configuración de tu cuenta, selecciona "Seguridad" y elige la opción para cambiar contraseña.',
    ),
    FAQItem(
      category: 'Cuenta',
      question: '¿Olvidé mi contraseña, qué hago?',
      answer:
          'En la pantalla de inicio de sesión selecciona "¿Olvidaste tu contraseña?" para recibir un correo con instrucciones de restablecimiento.',
    ),
    FAQItem(
      category: 'Cuenta',
      question: '¿Cómo cierro sesión?',
      answer:
          'Abre el menú lateral y selecciona "Cerrar sesión". Confirma para salir de tu cuenta.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _updateFilteredFAQs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilteredFAQs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFAQs = faqs.where((faq) {
        final matchesCategory =
            _selectedCategory == 'Todas' || faq.category == _selectedCategory;
        final matchesSearch =
            query.isEmpty ||
            faq.question.toLowerCase().contains(query) ||
            faq.answer.toLowerCase().contains(query);
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool modoOscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_azulPrincipal, _azulOscuro],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Preguntas Frecuentes',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _updateFilteredFAQs(),
              decoration: InputDecoration(
                hintText: 'Busca una pregunta...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _updateFilteredFAQs();
                        },
                      )
                    : null,
                filled: true,
                fillColor: modoOscuro ? Colors.grey[850] : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(category),
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      _updateFilteredFAQs();
                    },
                    backgroundColor: modoOscuro
                        ? Colors.grey[800]
                        : Colors.grey[200],
                    selectedColor: _azulPrincipal,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (modoOscuro ? Colors.white : Colors.black87),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _filteredFAQs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.help_outline_rounded,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No encontramos coincidencias',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: modoOscuro
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Intenta con otros términos de búsqueda',
                          style: TextStyle(
                            color: modoOscuro
                                ? Colors.grey[500]
                                : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: _filteredFAQs.length,
                    itemBuilder: (context, index) {
                      return _FAQItemWidget(
                        item: _filteredFAQs[index],
                        modoOscuro: modoOscuro,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String category;
  final String question;
  final String answer;

  FAQItem({
    required this.category,
    required this.question,
    required this.answer,
  });
}

class _FAQItemWidget extends StatefulWidget {
  final FAQItem item;
  final bool modoOscuro;

  const _FAQItemWidget({required this.item, required this.modoOscuro});

  @override
  State<_FAQItemWidget> createState() => _FAQItemWidgetState();
}

class _FAQItemWidgetState extends State<_FAQItemWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        elevation: _isExpanded ? 4 : 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            InkWell(
              onTap: _toggleExpand,
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF1565C0,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.item.category,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.item.question,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: widget.modoOscuro
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    RotationTransition(
                      turns: Tween<double>(
                        begin: 0,
                        end: 0.5,
                      ).animate(_animationController),
                      child: const Icon(
                        Icons.expand_more_rounded,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Visibility(
                visible: _isExpanded,
                child: Column(
                  children: [
                    Divider(height: 1, color: Colors.grey[300]),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.item.answer,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.modoOscuro
                              ? Colors.grey[300]
                              : Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
