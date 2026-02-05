import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/b_nav.dart';
import '../widgets/t_nav.dart';

import '../model/articles.dart';
import 'articles_web.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      resizeToAvoidBottomInset: true,
      appBar: TopNav(leading: const Icon(Icons.book_outlined)),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('articles').snapshots(),
          builder: (context, snapshot) {
            final bottomInset = MediaQuery.of(context).padding.bottom;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No articles found"));
            }

            final articles = snapshot.data!.docs
                .map((doc) => Article.fromFirestore(doc))
                .toList();

            return ListView.separated(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + kBottomNavigationBarHeight + bottomInset,
              ),
              itemCount: articles.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final article = articles[index];

                return ArticleTile(
                  article: article,
                  onTap: () async {
                    if (kIsWeb) {
                      await launchUrl(
                        Uri.parse(article.url),
                        webOnlyWindowName: '_blank',
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArticleWebViewPage(
                            title: article.title,
                            url: article.url,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const SafeArea(
        child: BottomNav(currentRoute: "/articles"),
      ),
    );
  }
}

class ArticleTile extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const ArticleTile({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: article.tileColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                article.title,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 140,
                height: 90,
                child: Image.network(
                  article.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.black.withValues(alpha: 0.06),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                  errorBuilder: (_, _, _) => Container(
                    color: Colors.black.withValues(alpha: 0.06),
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
