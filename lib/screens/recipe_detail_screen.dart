import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe.dart';
import '../models/comment.dart';
import '../models/rating.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double _rating = 3;
  Recipe? _updatedRecipe;

  @override
  void initState() {
    super.initState();
    _updatedRecipe = widget.recipe;
  }

  Future<void> _submitComment() async {
    if (_commentController.text.isEmpty) return;

    final user = _auth.currentUser;
    if (user == null) return;

    final comment = Comment(
      id: '',
      userEmail: user.email!,
      text: _commentController.text,
      timestamp: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('recetas')
        .doc(widget.recipe.id)
        .collection('comments')
        .add(comment.toMap());

    _commentController.clear();
    setState(() {});
  }

  Future<void> _deleteComment(String commentId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('recetas')
        .doc(widget.recipe.id)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  Future<void> _editComment(String commentId, String newText) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('recetas')
        .doc(widget.recipe.id)
        .collection('comments')
        .doc(commentId)
        .update({'text': newText});
  }

  Future<void> _submitRating(double rating) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final recipeRef = FirebaseFirestore.instance.collection('recetas').doc(widget.recipe.id);
    final ratingRef = recipeRef.collection('ratings').doc(user.email);
    final ratingDoc = await ratingRef.get();

    if (ratingDoc.exists) {
      await ratingRef.update({'value': rating});
    } else {
      await ratingRef.set(Rating(userEmail: user.email!, value: rating).toMap());
    }

    final ratingsSnapshot = await recipeRef.collection('ratings').get();
    final ratings = ratingsSnapshot.docs.map((doc) => Rating.fromMap(doc.data())).toList();
    final newRatingCount = ratings.length;
    final newRating = ratings.map((r) => r.value).reduce((a, b) => a + b) / newRatingCount;

    await recipeRef.update({
      'rating': newRating,
      'ratingCount': newRatingCount,
    });

    setState(() {
      _updatedRecipe = Recipe(
        id: _updatedRecipe!.id,
        name: _updatedRecipe!.name,
        instruction: _updatedRecipe!.instruction,
        ingredients: _updatedRecipe!.ingredients,
        keywords: _updatedRecipe!.keywords,
        time: _updatedRecipe!.time,
        imageUrl: _updatedRecipe!.imageUrl,
        rating: newRating,
        ratingCount: newRatingCount,
      );
    });
  }

  void _showEditDialog(Comment comment) {
    final TextEditingController _editController = TextEditingController(text: comment.text);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar comentario'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(hintText: 'Nuevo texto'),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                _editComment(comment.id, _editController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_updatedRecipe!.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_updatedRecipe!.imageUrl != null)
              Image.network(_updatedRecipe!.imageUrl!),
            SizedBox(height: 16),
            Text(
              _updatedRecipe!.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Tiempo: ${_updatedRecipe!.time}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Ingredientes: ${_updatedRecipe!.ingredients.join(', ')}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Instrucciones: ${_updatedRecipe!.instruction}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Calificación: ${_updatedRecipe!.rating.toStringAsFixed(1)} (${_updatedRecipe!.ratingCount} calificaciones)',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                DropdownButton<double>(
                  value: _rating,
                  onChanged: (newValue) {
                    setState(() {
                      _rating = newValue!;
                    });
                    _submitRating(_rating);
                  },
                  items: [1, 2, 3, 4, 5].map((value) {
                    return DropdownMenuItem<double>(
                      value: value.toDouble(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Agregar comentario',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _submitComment,
                ),
              ),
            ),
            SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('recetas')
                  .doc(widget.recipe.id)
                  .collection('comments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final comments = snapshot.data!.docs
                    .map((doc) => Comment.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                    .toList();
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      title: Text(comment.userEmail),
                      subtitle: Text(comment.text),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (comment.userEmail == _auth.currentUser?.email)
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _showEditDialog(comment),
                            ),
                          if (comment.userEmail == _auth.currentUser?.email)
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteComment(comment.id),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TimeAgo {
  static String format(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 8) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} días atrás';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} horas atrás';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutos atrás';
    } else {
      return 'justo ahora';
    }
  }
}
