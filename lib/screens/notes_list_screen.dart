import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/note.dart';
import '../services/firestore_service.dart';
import 'add_edit_note_screen.dart';

class NotesListScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  // A vibrant palette for the note cards
  final List<Color> cardColors = const [
    Color(0xFFE5748F), // Pink
    Color(0xFF99EDCC), // Mint
    Color(0xFFFBBF24), // Amber
    Color(0xFFA78BFA), // Purple
    Color(0xFF60A5FA), // Blue
  ];

  NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 26, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B).withValues(alpha: 0.8), // Distinct App Bar Color
        elevation: 10,
        shadowColor: Colors.black45,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF347D69), Color(0xFF0F172A)], // Teal to Deep Blue Background
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<List<Note>>(
            stream: _firestoreService.getNotes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFFBBF24)));
              }

              final notes = snapshot.data ?? [];

              if (notes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.note_alt_outlined, size: 80, color: const Color(0xFF99EDCC).withValues(alpha: 0.7))
                          .animate(onPlay: (controller) => controller.repeat())
                          .shimmer(duration: 2000.ms, color: const Color(0xFFE5748F)),
                      const SizedBox(height: 16),
                      Text(
                        'No notes yet.\nCreate something brilliant!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 18),
                      ),
                    ],
                  ).animate().fade(duration: 500.ms).scale(curve: Curves.easeOutBack),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  mainAxisExtent: 160, // Fixed height for cards
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 0,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  // Assign a different color from the palette based on index
                  final cardColor = cardColors[index % cardColors.length];
                  
                  return _AnimatedNoteCard(
                    note: note,
                    accentColor: cardColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => AddEditNoteScreen(note: note),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                      );
                    },
                    onDelete: () => _showDeleteDialog(context, note.id!),
                  ).animate().fade(delay: (50 * index).ms).scale(curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8));
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const AddEditNoteScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        backgroundColor: const Color(0xFFE5748F), // Pink FAB
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Note', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ).animate().scale(delay: 500.ms, curve: Curves.elasticOut),
    );
  }

  void _showDeleteDialog(BuildContext context, String noteId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE5748F), width: 2)
        ),
        title: const Text('Delete Note', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this note?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF99EDCC))), // Mint cancel button
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE5748F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              _firestoreService.deleteNote(noteId);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _AnimatedNoteCard extends StatefulWidget {
  final Note note;
  final Color accentColor;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _AnimatedNoteCard({
    required this.note, 
    required this.accentColor,
    required this.onTap, 
    required this.onDelete
  });

  @override
  State<_AnimatedNoteCard> createState() => _AnimatedNoteCardState();
}

class _AnimatedNoteCardState extends State<_AnimatedNoteCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 16),
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _isHovered ? 1.03 : 1.0,
          _isHovered ? 1.03 : 1.0,
          1.0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Material(
              color: widget.accentColor.withValues(alpha: 0.15), // Uses the unique card color
              child: InkWell(
                onTap: widget.onTap,
                splashColor: widget.accentColor.withValues(alpha: 0.3),
                highlightColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isHovered 
                          ? widget.accentColor.withValues(alpha: 0.8) 
                          : widget.accentColor.withValues(alpha: 0.3),
                      width: _isHovered ? 2.5 : 1.5,
                    ),
                    boxShadow: _isHovered ? [
                      BoxShadow(
                        color: widget.accentColor.withValues(alpha: 0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ] : [],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.note.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.note.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white.withValues(alpha: 0.8),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: _isHovered ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete_sweep_rounded, 
                            color: _isHovered ? const Color(0xFFE5748F) : Colors.white70,
                            size: 28,
                          ),
                          onPressed: widget.onDelete,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
