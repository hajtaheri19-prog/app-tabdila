import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/utils/digit_utils.dart';

class InvoiceItem {
  String name;
  String description;
  double quantity;
  double unitPrice;

  InvoiceItem({
    required this.name,
    this.description = '',
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;
}

class InvoiceMakerPage extends StatefulWidget {
  const InvoiceMakerPage({super.key});

  @override
  State<InvoiceMakerPage> createState() => _InvoiceMakerPageState();
}

class _InvoiceMakerPageState extends State<InvoiceMakerPage> {
  final List<InvoiceItem> _items = [
    InvoiceItem(
        name: 'طراحی رابط کاربری اپلیکیشن',
        description: 'پروژه فاز یک',
        quantity: 1,
        unitPrice: 5000000),
    InvoiceItem(
        name: 'توسعه فرانت‌بند وبسایت',
        description: 'صفحه اصلی و داشبورد',
        quantity: 1.5,
        unitPrice: 5000000),
  ];

  final TextEditingController _sellerNameController = TextEditingController();
  final TextEditingController _sellerIdController = TextEditingController();
  final TextEditingController _sellerPhoneController = TextEditingController();
  final TextEditingController _sellerAddressController =
      TextEditingController();

  final TextEditingController _buyerNameController = TextEditingController();
  final TextEditingController _invoiceNumberController =
      TextEditingController();
  final TextEditingController _invoiceDateController = TextEditingController();

  bool _applyVat = true;
  String _selectedTemplate = 'ونوس (رسمی)';

  XFile? _logoImage;
  XFile? _sellerSignatureImage;
  XFile? _buyerSignatureImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (type == 'logo') _logoImage = image;
        if (type == 'seller') _sellerSignatureImage = image;
        if (type == 'buyer') _buyerSignatureImage = image;
      });
    }
  }

  double get _subtotal => _items.fold(0, (sum, item) => sum + item.total);
  double get _vatAmount => _applyVat ? _subtotal * 0.1 : 0;
  double get _totalAmount => _subtotal + _vatAmount;

  final currencyFormatter = intl.NumberFormat('#,###', 'fa_IR');

  void _addItem() {
    setState(() {
      _items.add(InvoiceItem(name: 'ردیف جدید', quantity: 1, unitPrice: 0));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    // Load Persian fonts
    final fontData =
        await rootBundle.load('assets/fonts/Vazirmatn-Regular.ttf');
    final fontDataBold =
        await rootBundle.load('assets/fonts/Vazirmatn-Bold.ttf');
    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(fontDataBold);
    final theme = pw.ThemeData.withFont(base: ttf, bold: ttfBold);

    Uint8List? logoBytes;
    if (_logoImage != null) {
      logoBytes = await _logoImage!.readAsBytes();
    }

    Uint8List? sellerSignBytes;
    if (_sellerSignatureImage != null) {
      sellerSignBytes = await _sellerSignatureImage!.readAsBytes();
    }

    Uint8List? buyerSignBytes;
    if (_buyerSignatureImage != null) {
      buyerSignBytes = await _buyerSignatureImage!.readAsBytes();
    }

    pdf.addPage(
      pw.Page(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    if (logoBytes != null)
                      pw.Container(
                        width: 80,
                        height: 80,
                        child: pw.Image(pw.MemoryImage(logoBytes)),
                      )
                    else
                      pw.SizedBox(width: 80),
                    pw.Text('فاکتور فروش - تبدیلا',
                        style: pw.TextStyle(
                            fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(width: 80),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                        'تاریخ: ${DigitUtils.toFarsi(_invoiceDateController.text)}'),
                    pw.Text(
                        'شماره فاکتور: ${DigitUtils.toFarsi(_invoiceNumberController.text)}'),
                  ],
                ),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                          'فروشنده: ${DigitUtils.toFarsi(_sellerNameController.text)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          'شماره تماس: ${DigitUtils.toFarsi(_sellerPhoneController.text)}'),
                      pw.Text(
                          'آدرس: ${DigitUtils.toFarsi(_sellerAddressController.text)}'),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                          'خریدار: ${DigitUtils.toFarsi(_buyerNameController.text)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.TableHelper.fromTextArray(
                  context: context,
                  border: pw.TableBorder.all(color: PdfColors.grey),
                  headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration:
                      const pw.BoxDecoration(color: PdfColors.purple),
                  cellStyle: const pw.TextStyle(fontSize: 10),
                  headerAlignment: pw.Alignment.center,
                  cellAlignment: pw.Alignment.center,
                  data: <List<String>>[
                    <String>[
                      'ردیف',
                      'شرح کالا / خدمات',
                      'تعداد',
                      'قیمت واحد (ریال)',
                      'قیمت کل (ریال)'
                    ],
                    ..._items.asMap().entries.map((e) => [
                          DigitUtils.toFarsi((e.key + 1).toString()),
                          DigitUtils.toFarsi(e.value.name),
                          DigitUtils.toFarsi(e.value.quantity.toString()),
                          DigitUtils.toFarsi(
                              currencyFormatter.format(e.value.unitPrice)),
                          DigitUtils.toFarsi(
                              currencyFormatter.format(e.value.total))
                        ])
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                            'جمع کل: ${DigitUtils.toFarsi(currencyFormatter.format(_subtotal))} ریال'),
                        if (_applyVat)
                          pw.Text(
                              'مالیات بر ارزش افزوده (۱۰٪): ${DigitUtils.toFarsi(currencyFormatter.format(_vatAmount))} ریال'),
                        pw.SizedBox(height: 5),
                        pw.Text(
                            'مبلـغ قابـل پـرداخت: ${DigitUtils.toFarsi(currencyFormatter.format(_totalAmount))} ریال',
                            style: pw.TextStyle(
                                fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text('مهر و امضای فروشنده'),
                        if (sellerSignBytes != null)
                          pw.Container(
                            width: 100,
                            height: 60,
                            child: pw.Image(pw.MemoryImage(sellerSignBytes)),
                          )
                        else
                          pw.SizedBox(height: 60),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text('مهر و امضای خریدار'),
                        if (buyerSignBytes != null)
                          pw.Container(
                            width: 100,
                            height: 60,
                            child: pw.Image(pw.MemoryImage(buyerSignBytes)),
                          )
                        else
                          pw.SizedBox(height: 60),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF7F13EC);
    const backgroundDark = Color(0xFF191022);
    const surfaceDark = Color(0xFF2A1E36);
    const inputBgColor = Color(0xFF362348);
    const secondaryColor = Color(0xFFAD92C9);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(primaryColor),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTemplateSelector(
                            primaryColor, surfaceDark, secondaryColor),
                        const SizedBox(height: 24),

                        _buildExpandableCard(
                          title: 'اطلاعات فروشنده',
                          icon: Icons.storefront,
                          iconColor: primaryColor,
                          surfaceColor: surfaceDark,
                          secondaryColor: secondaryColor,
                          children: [
                            _buildInputField(
                                'نام فروشگاه / شخص',
                                _sellerNameController,
                                inputBgColor,
                                secondaryColor,
                                hint: 'مثال: فروشگاه ساره'),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                    child: _buildInputField(
                                        'کد اقتصادی / ملی',
                                        _sellerIdController,
                                        inputBgColor,
                                        secondaryColor,
                                        ltr: true,
                                        hint: '0123456789')),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: _buildInputField(
                                        'شماره تماس',
                                        _sellerPhoneController,
                                        inputBgColor,
                                        secondaryColor,
                                        ltr: true,
                                        hint: '021-12345678')),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildInputField('آدرس', _sellerAddressController,
                                inputBgColor, secondaryColor,
                                maxLines: 2, hint: 'نشانی دقیق پستی...'),
                          ],
                        ),

                        const SizedBox(height: 12),

                        _buildExpandableCard(
                          title: 'اطلاعات خریدار',
                          icon: Icons.person,
                          iconColor: const Color(0xFF10B981),
                          surfaceColor: surfaceDark,
                          secondaryColor: secondaryColor,
                          children: [
                            _buildInputField(
                                'نام خریدار / شرکت',
                                _buyerNameController,
                                inputBgColor,
                                secondaryColor,
                                hint: 'نام دریافت‌کننده فاکتور'),
                          ],
                        ),

                        const SizedBox(height: 24),

                        _buildItemsSection(primaryColor, surfaceDark,
                            inputBgColor, secondaryColor),

                        const SizedBox(height: 24),

                        _buildSettingsCard(surfaceDark, inputBgColor,
                            primaryColor, secondaryColor),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: _buildBrandingCard(
                                'آپلود لوگو',
                                Icons.image,
                                surfaceDark,
                                secondaryColor,
                                _logoImage,
                                () => _pickImage('logo'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSignatureCard(
                                'امضای فروشنده',
                                primaryColor,
                                surfaceDark,
                                secondaryColor,
                                _sellerSignatureImage,
                                () => _pickImage('seller'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSignatureCard(
                                'امضای خریدار',
                                const Color(0xFF10B981),
                                surfaceDark,
                                secondaryColor,
                                _buyerSignatureImage,
                                () => _pickImage('buyer'),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        _buildFeaturesGrid(
                            surfaceDark, secondaryColor, primaryColor),

                        const SizedBox(
                            height: 100), // Spacing for bottom actions
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          _buildBottomActions(primaryColor, backgroundDark),
        ],
      ),
    );
  }

  Widget _buildAppBar(Color primary) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
          Text(
            'فاکتورساز حرفه‌ای',
            style: GoogleFonts.vazirmatn(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.save, color: primary),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateSelector(Color primary, Color surface, Color secondary) {
    final templates = ['ونوس (رسمی)', 'کلاسیک', 'کهکشانی', 'اقیانوسی'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'انتخاب قالب',
          style: GoogleFonts.vazirmatn(
              fontSize: 12, color: secondary, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: templates.map((t) {
              final isSelected = _selectedTemplate == t;
              return GestureDetector(
                onTap: () => setState(() => _selectedTemplate = t),
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? primary : surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color: isSelected
                            ? primary
                            : Colors.white.withOpacity(0.1)),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                                color: primary.withOpacity(0.3), blurRadius: 10)
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      if (isSelected)
                        const Icon(Icons.verified,
                            color: Colors.white, size: 16),
                      if (isSelected) const SizedBox(width: 6),
                      Text(
                        t,
                        style: GoogleFonts.vazirmatn(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color surfaceColor,
    required Color secondaryColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ExpansionTile(
            initiallyExpanded: title == 'اطلاعات فروشنده',
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            title: Text(
              title,
              style: GoogleFonts.vazirmatn(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            iconColor: Colors.white70,
            collapsedIconColor: Colors.white70,
            childrenPadding: const EdgeInsets.all(16),
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      Color bgColor, Color secondary,
      {bool ltr = false, int maxLines = 1, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.vazirmatn(fontSize: 11, color: secondary)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          textAlign: ltr ? TextAlign.left : TextAlign.right,
          style: GoogleFonts.vazirmatn(fontSize: 13, color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: bgColor,
            hintText: hint,
            hintStyle:
                GoogleFonts.vazirmatn(fontSize: 12, color: Colors.white24),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(
      Color primary, Color surface, Color inputBg, Color secondary) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('اقلام فاکتور',
                style: GoogleFonts.vazirmatn(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Text(
              'مجموع: ${currencyFormatter.format(_totalAmount)} تومان',
              style: GoogleFonts.vazirmatn(fontSize: 12, color: secondary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._items
            .asMap()
            .entries
            .map((entry) => _buildItemCard(
                entry.key, entry.value, surface, primary, inputBg, secondary))
            .toList(),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _addItem,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primary, style: BorderStyle.solid),
              color: primary.withOpacity(0.05),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle, color: primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'افزودن ردیف جدید',
                  style: GoogleFonts.vazirmatn(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(int index, InvoiceItem item, Color surface,
      Color primary, Color inputBg, Color secondary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
                width: 4,
                decoration: BoxDecoration(
                    color: primary,
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(16)))),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInlineEdit(item, true),
                          _buildInlineEdit(item, false),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _removeItem(index),
                      icon: const Icon(Icons.delete,
                          color: Colors.redAccent, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildItemInput('تعداد', (val) {
                        setState(() => item.quantity =
                            double.tryParse(DigitUtils.toEnglish(val)) ?? 0);
                      }, DigitUtils.toFarsi(item.quantity.toString()), inputBg,
                          true),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _buildItemInput('قیمت واحد (تومان)', (val) {
                        setState(() => item.unitPrice =
                            double.tryParse(DigitUtils.toEnglish(val)) ?? 0);
                      }, DigitUtils.toFarsi(item.unitPrice.toString()), inputBg,
                          false),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineEdit(InvoiceItem item, bool isName) {
    return TextField(
      onChanged: (val) => isName ? item.name = val : item.description = val,
      controller:
          TextEditingController(text: isName ? item.name : item.description),
      style: GoogleFonts.vazirmatn(
        fontSize: isName ? 14 : 11,
        fontWeight: isName ? FontWeight.bold : FontWeight.normal,
        color: isName ? Colors.white : Colors.white60,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        hintText: isName ? 'نام کالا / سرویس' : 'توضیحات (اختیاری)',
        hintStyle: GoogleFonts.vazirmatn(
            fontSize: isName ? 14 : 11, color: Colors.white24),
      ),
    );
  }

  Widget _buildItemInput(String label, Function(String) onChanged,
      String initial, Color bgColor, bool center) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.vazirmatn(fontSize: 10, color: Colors.white24)),
        const SizedBox(height: 4),
        TextField(
          onChanged: onChanged,
          controller: TextEditingController(text: initial)
            ..selection = TextSelection.fromPosition(
                TextPosition(offset: initial.length)),
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: GoogleFonts.vazirmatn(
              fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: bgColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(
      Color surface, Color inputBg, Color primary, Color secondary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('تنظیمات و جزئیات',
              style: GoogleFonts.vazirmatn(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildInputField('شماره فاکتور',
                      _invoiceNumberController, inputBg, secondary,
                      hint: '1402-0042')),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildInputField(
                      'تاریخ صدور', _invoiceDateController, inputBg, secondary,
                      ltr: false, hint: '1402/10/25')),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white10),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('مالیات بر ارزش افزوده',
                      style: GoogleFonts.vazirmatn(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text('افزودن ۱۰٪ به مبلغ کل',
                      style: GoogleFonts.vazirmatn(
                          fontSize: 11, color: secondary)),
                ],
              ),
              Switch(
                value: _applyVat,
                onChanged: (val) => setState(() => _applyVat = val),
                activeColor: primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBrandingCard(String label, IconData icon, Color surface,
      Color secondary, XFile? image, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05))),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: kIsWeb
                    ? Image.network(image.path, fit: BoxFit.contain)
                    : Image.file(File(image.path), fit: BoxFit.contain),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white24, size: 30),
                  const SizedBox(height: 8),
                  Text(label,
                      style: GoogleFonts.vazirmatn(
                          fontSize: 11, color: secondary)),
                ],
              ),
      ),
    );
  }

  Widget _buildSignatureCard(String label, Color color, Color surface,
      Color secondary, XFile? image, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05))),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: kIsWeb
                    ? Image.network(image.path, fit: BoxFit.contain)
                    : Image.file(File(image.path), fit: BoxFit.contain),
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                      size: const Size(80, 40),
                      painter: _SignaturePainter(color)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: surface.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(label,
                        style: GoogleFonts.vazirmatn(
                            fontSize: 11, color: secondary)),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFeaturesGrid(Color surface, Color secondary, Color primary) {
    final features = [
      {'icon': Icons.credit_card, 'label': 'پرداخت آنلاین'},
      {'icon': Icons.history, 'label': 'تاریخچه'},
      {'icon': Icons.bar_chart, 'label': 'گزارشات'},
      {'icon': Icons.draw, 'label': 'امضای دیجیتال'},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: features
          .map((f) => Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.05))),
                    child:
                        Icon(f['icon'] as IconData, color: secondary, size: 24),
                  ),
                  const SizedBox(height: 6),
                  Text(f['label'] as String,
                      style: GoogleFonts.vazirmatn(
                          fontSize: 10, color: secondary)),
                ],
              ))
          .toList(),
    );
  }

  Widget _buildBottomActions(Color primary, Color background) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [background.withOpacity(0), background]),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _generatePdf,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                  shadowColor: primary.withOpacity(0.5),
                ),
                icon: const Icon(Icons.print),
                label: Text('چاپ یا دریافت PDF',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: const Color(0xFF2A1E36),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10)),
              child: IconButton(
                onPressed: () => Share.share('فاکتور من از اپلیکیشن تبدیلا'),
                icon: const Icon(Icons.share, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final Color color;
  _SignaturePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.1, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.1, size.width * 0.6,
          size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.9, size.width * 0.9,
          size.height * 0.3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
