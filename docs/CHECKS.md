# Checks and report files

## 30+ checks every audit

<table>
<tr>
<td valign="top" width="50%">

#### 🔒 Security & headers
`missing_hsts_header` · `missing_csp_header` · `missing_x_frame_options` · `missing_x_content_type_options` · `missing_referrer_policy` · `x_robots_tag_vs_meta_mismatch` · `mixed_content`

#### 🛡️ WAF / bot-block detection
`bot_block_challenge_detected`: fingerprints **Cloudflare · Akamai · DataDome · Imperva · PerimeterX**

#### 🗺️ Sitemap & robots
`sitemap_url_noindex` · `sitemap_url_3xx` · `sitemap_url_disallowed_in_robots` · `sitemap_contains_canonicalized` · `sitemap_over_50k_urls` · `sitemap_over_50mb`

#### 🌍 Hreflang full audit
`hreflang_missing_return_tag` · `hreflang_missing_self_reference` · `hreflang_missing_x_default` · `hreflang_invalid_codes` · `hreflang_to_noindex` · `hreflang_to_broken` · `hreflang_conflicts_lang_attr`

#### 🔗 Canonical health
`canonical_chain_depth` · `canonical_to_relative` · `canonical_to_redirect` · `canonical_outside_head` · `bad_canonical`

#### 🔁 Redirects (every flavour)
`redirect_chains` · `meta_refresh_redirect` · `js_redirect` · `http_refresh_redirect`

#### 🏷️ Schema.org (16 types)
Article · Product · Recipe · FAQPage · BreadcrumbList · Event · JobPosting · VideoObject · HowTo · Organization · LocalBusiness · Person · Review · AggregateRating · Course · NewsArticle: validates **schema.org spec** AND **Google Rich Results** required fields. Handles `@graph` (Yoast / Rank Math / WPRM).

</td>
<td valign="top" width="50%">

#### 🔤 URL quality
`url_contains_space` · `url_multiple_slashes` · `url_non_ascii` · `url_underscores` · `url_repetitive_path` · `long_urls` · `uppercase_urls` · `url_params_heavy`

#### ⚓ Anchor text
`non_descriptive_anchor_text` · `empty_anchor_text` · `anchor_image_no_alt` · `broken_bookmarks`

#### 🕸️ Internal linking
`internal_nofollow_outlinks` · `nofollow_only_inbound` · `follow_and_nofollow_mixed` · `orphan_pages`

#### 🖼️ Image performance + CLS
`lazy_load_attr_missing` · `srcset_missing` · `image_dimensions_missing` · `next_gen_image_format` · `missing_alt_pages` · `broken_img_pages`

#### 📐 HTML structure
`html_over_2mb` · `noscript_in_head` · `broken_or_invalid_html` · `dom_size_excessive` · `lorem_ipsum_detected`

#### ♿ Accessibility / metadata
`iframes_present` · `iframe_missing_title` · `missing_favicon` · `missing_viewport`

#### 🪤 Crawl-budget killers
`spider_trap_calendar` · `url_session_id_high_entropy` · `faceted_url_explosion`

#### ✍️ Content quality
`low_readability` (Flesch) · `long_sentences` · `passive_voice_pct` · `missing_terminal_punctuation` · `boilerplate_ratio` · `ai_tell_tokens_found` (delve · unlock · seamlessly · leverage) · `has_lorem_ipsum`

#### 🚨 Dev leaks
`outlinks_to_localhost` (RFC1918 in production)

</td>
</tr>
</table>

**🔗 Every outbound URL HEAD/GET-validated** into 17 status classes: `ok` · `redirect` · `forbidden` · `not_found` · `timeout` · `dns_error` · `ssl_error` · `connection_refused` · etc. Per-target: final URL after redirects, source pages, anchor text, response time, server header.

**📈 GSC merge**: pull Google Search Console data, call `librecrawl_merge_gsc_data(crawl_id, gsc_data)`. URLs normalised before joining. Emits **4 extra CSVs**: `per-page-with-gsc` · `gsc-winners` · `gsc-losers` (high impr + CTR <2%) · `gsc-quick-wins` (position 11 to 20 + impr ≥100).

---


## What every audit produces

Single zip, 9 files:

| File | Use |
|---|---|
| `SUMMARY.txt` | One-page orientation |
| `<domain>-<ts>.pdf` | **Branded human-readable PDF** (open in any viewer) |
| `<domain>-<ts>.md` | Markdown source of the PDF (grep-friendly) |
| `per-page.csv` | 1 row per URL × 30 columns of check booleans + `failed_checks_list` + `fetch_error` |
| `sitemap-recon.csv` | Sitemap-vs-crawl diff |
| `external-links.csv` | Every outbound URL + status |
| `content-audit.csv` | Per-page readability + AI-tells |
| `extended-checks.csv` | 1 row per (URL × check × severity × detail): all 30+ checks |
| `schema-validation.csv` | JSON-LD findings per page against schema.org and Google rich-result required fields |

---
