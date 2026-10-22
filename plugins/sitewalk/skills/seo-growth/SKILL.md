---
name: seo-growth
description: Run a technical SEO audit of a website with Sitewalk and turn it into a ranked fix plan, then re-check after the fixes ship. Use when the user says "audit my site", "SEO check", "why is my site not ranking", "why are my pages not indexed", "find broken links", "check redirects", "check canonicals", "site health report", "crawl my site", "Screaming Frog this site", or gives a URL and asks what to fix for SEO.
---

# SEO growth loop with Sitewalk

Sitewalk crawls a website the way a search engine bot reads it and returns every technical SEO problem ranked by impact, each with a plain-English fix and example pages. This skill drives that audit and turns the result into work the user can ship.

## Which tools you have

Use whichever Sitewalk server is connected. Do not ask the user which one.

| Server | Tools | Notes |
|---|---|---|
| Hosted (`https://audit.adityaarsharma.com/mcp`) | `start_site_audit(url)`, `get_audit_status(audit_id)`, `get_audit_report(audit_id, top_n)` | Free account: 3 audits a month. Up to 50 pages for a site the user has not verified, up to 500 for a verified site. The first call asks the user to sign in with their email. |
| Self-hosted (this repo) | `librecrawl_start_chunked_audit(url)`, `librecrawl_audit_status(session_id)`, `librecrawl_audit_zip(session_id)`, `librecrawl_audit_confirm_saved(session_id, sha256)` | No page caps. Save the zip locally and confirm it, as the server instructions say. |

If neither is connected, tell the user how to add one (see "Connect Sitewalk" below) and stop.

## The loop

1. **Pin the target.** One URL, with the scheme (`https://example.com`). If the user named a page, audit the site root unless they asked for that page only. Ask what they care about most only if it changes the order of fixes (for example a shop that lives on product pages).
2. **Start the audit.** Call the start tool once. If it returns a sign-in step, tell the user to finish signing in and then ask again. Never start a second audit of the same site while one is running.
3. **Wait honestly.** Sitewalk fetches about one page every 2 seconds to stay gentle on the site, so 50 pages take about 2 minutes and 500 pages about 20. Poll the status tool every 20 to 30 seconds. Tell the user the progress in one line, not a stream of updates.
4. **Read the whole report.** Fetch it with a top_n large enough to see every issue type. Every claim you make must come from the report. Never add an issue the crawl did not find, and never guess a page count.
5. **Rank the work.** The report is already ordered by impact (severity times pages affected). Pick the top three and say why each matters in one sentence, in terms of search traffic or indexing, not jargon.
6. **Write the fix plan.** For each issue: what is wrong, the pages affected (up to five examples, then the count), the exact fix, and how to confirm it is fixed. If you can see the site's code or CMS in this workspace, write the fix in that stack: WordPress (Yoast, Rank Math, `.htaccess`), Next.js (`metadata`, `redirects()` in `next.config`), Shopify (theme Liquid, URL redirects), static HTML.
7. **Offer to apply it.** In an editor with the site's repository open, offer to make the changes. Do not edit files without the user's go-ahead.
8. **Re-check.** After the user ships fixes, run the audit again and compare: issues fixed, issues still open, anything new. On the hosted free plan each run uses one of 3 monthly audits, so suggest fixing a batch first.

## Output shape

```
Audit of example.com: 212 pages crawled, 9 issue types.

Fix first
1. 38 pages have no meta description (High). Search engines write their own snippet, which usually lowers clicks.
   Fix: write a 140 to 160 character description per page. Examples: /pricing, /blog/x, ...
   Check: re-run the audit; the issue count should be 0.
2. ...
3. ...

Also found: <the remaining issue types in one line each>
Full report: <report link from the tool>
```

## Rules

- Report only what the crawl found. If the crawl was capped (50 pages on an unverified site), say so and explain that verifying the site raises the cap to 500 at https://audit.adityaarsharma.com/app/#sites.
- A site that blocks crawlers in robots.txt, or answers 403 or 429, is reported as blocked, not as clean.
- Sitewalk identifies itself as SitewalkBot and obeys robots.txt. Do not try to work around a block.
- Keep the user's quota in mind. Do not re-run an audit to answer a question the existing report already answers.
- Plain English. The user may not be an SEO.

## Connect Sitewalk

- Claude Code: `claude mcp add --transport http sitewalk https://audit.adityaarsharma.com/mcp` (this plugin already adds it).
- Cursor: Settings, MCP, add a server with URL `https://audit.adityaarsharma.com/mcp`, or use the Add to Cursor button in the repository README.
- ChatGPT: open https://audit.adityaarsharma.com/plugin/chatgpt/ and add Sitewalk. No install.
- Self-hosted with no page caps: follow https://github.com/adityaarsharma/sitewalk#-install-in-60-seconds
