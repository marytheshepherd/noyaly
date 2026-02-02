import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

import '../widgets/b_nav.dart';
import '../widgets/t_nav.dart';

import '../data/article_bank.dart';
import '../model/articles.dart';
import 'articles_web.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  final List<Article> _articles = articlesData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNav(leading: const Icon(Icons.book_outlined)),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _articles.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final article = _articles[index];

            return ArticleTile(
              article: article,
              onTap: () async {
                if (kIsWeb) {
                  final uri = Uri.parse(article.url);
                  await launchUrl(uri, webOnlyWindowName: '_blank');
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
                  errorBuilder: (_, __, ___) => Container(
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
