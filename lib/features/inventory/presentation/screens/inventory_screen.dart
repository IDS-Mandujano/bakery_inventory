import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transactional_app/features/inventory/presentation/providers/inventory_view_model.dart';
import 'package:transactional_app/features/inventory/domain/entities/product_entity.dart';
import 'package:transactional_app/features/login/presentation/screens/login_screen.dart';

import 'package:transactional_app/core/presentation/widgets/loading_indicator.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryViewModel>().loadProducts();
    });
  }

  void _showProductForm({Product? product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => ProductFormDialog(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<InventoryViewModel>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, viewModel),
          if (viewModel.isLoading && viewModel.products.isEmpty)
            const SliverFillRemaining(child: LoadingIndicator())
          else if (viewModel.errorMessage != null && viewModel.products.isEmpty)
            _buildErrorState(viewModel)
          else if (viewModel.products.isEmpty)
            const SliverFillRemaining(child: Center(child: Text('No hay productos en el inventario')))
          else
            _buildProductList(viewModel),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProductForm(),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Pan'),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, InventoryViewModel viewModel) {
    return SliverAppBar.large(
      title: const Text('Bakery Inventory'),
      centerTitle: true,
      actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: viewModel.loadProducts),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(InventoryViewModel viewModel) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(viewModel.errorMessage!),
            TextButton(onPressed: viewModel.loadProducts, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(InventoryViewModel viewModel) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => ProductCard(
            product: viewModel.products[index],
            onTap: () => _showProductForm(product: viewModel.products[index]),
          ),
          childCount: viewModel.products.length,
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.bakery_dining_outlined, color: theme.colorScheme.primary),
          ),
          title: Text(product.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          subtitle: _buildSubtitle(theme),
          onTap: onTap,
          trailing: const Icon(Icons.edit_outlined),
        ),
      ),
    );
  }

  Widget _buildSubtitle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Chip(
            label: Text('\$${product.price}'),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            backgroundColor: theme.colorScheme.secondaryContainer.withOpacity(0.5),
          ),
          const SizedBox(width: 8),
          Text(
            'Stock: ${product.stock}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: product.stock < 10 ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
              fontWeight: product.stock < 10 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductFormDialog extends StatefulWidget {
  final Product? product;
  const ProductFormDialog({super.key, this.product});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _stockController = TextEditingController(text: widget.product?.stock.toString() ?? '');
  }

  void _handleSave(BuildContext context, InventoryViewModel viewModel) async {
    final name = _nameController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final stock = int.tryParse(_stockController.text) ?? 0;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingresa un nombre')));
      return;
    }

    final success = widget.product == null
        ? await viewModel.addProduct(name, price, stock)
        : await viewModel.updateProduct(widget.product!.id, name, price, stock);

    if (success && context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.product == null ? 'Producto agregado' : 'Producto actualizado')),
      );
    } else if (context.mounted && viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage!), backgroundColor: Colors.red),
      );
    }
  }

  void _handleDelete(BuildContext context, InventoryViewModel viewModel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content: Text('¿Estás seguro de eliminar "${widget.product!.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await viewModel.deleteProduct(widget.product!.id);
      if (success && context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto eliminado')),
        );
      } else if (context.mounted && viewModel.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(viewModel.errorMessage!), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<InventoryViewModel>();
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16, left: 24, right: 24, top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGrabber(theme),
          const SizedBox(height: 24),
          _buildHeader(theme, viewModel),
          const SizedBox(height: 24),
          _buildFields(),
          const SizedBox(height: 32),
          _buildSubmitButton(viewModel),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGrabber(ThemeData theme) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4), borderRadius: BorderRadius.circular(2)),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, InventoryViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.product == null ? 'Nuevo Producto' : 'Editar Producto', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        if (widget.product != null)
          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _handleDelete(context, viewModel)),
      ],
    );
  }

  Widget _buildFields() {
    return Column(
      children: [
        TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nombre del Pan', prefixIcon: Icon(Icons.bakery_dining))),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: TextField(controller: _priceController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Precio', prefixIcon: Icon(Icons.attach_money)))),
            const SizedBox(width: 16),
            Expanded(child: TextField(controller: _stockController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock', prefixIcon: Icon(Icons.inventory_2_outlined)))),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton(InventoryViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: viewModel.isLoading ? null : () => _handleSave(context, viewModel),
        child: viewModel.isLoading
            ? const LoadingIndicator(isInButton: true)
            : Text(widget.product == null ? 'Agregar' : 'Actualizar'),
      ),
    );
  }
}