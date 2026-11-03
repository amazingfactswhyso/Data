# The Decor Zudio: website setup (all free)

Files: `index.html` (the whole website), `supabase-setup.sql` (database and image storage rules).

## 1. Free database and login (Supabase)
1. Create a free project at https://supabase.com/.
2. **Authentication > Users > Add user**: your email and a strong password, tick auto-confirm. Then in **Authentication > Sign In / Providers**, turn off "Allow new users to sign up" so nobody else can create accounts.
3. Open `supabase-setup.sql`, replace `artist@example.com` (one place only, inside `is_artist()`) with that exact email, then paste it into **SQL Editor** and run it.
4. **Project Settings > API**: copy the Project URL and the publishable (anon) key. Never use the secret/service_role key.
5. In `index.html`, find the settings block near the bottom and fill in:
   `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `OWNER_EMAIL` (same email as step 3), `CONTACT_EMAIL`, and optionally `INSTAGRAM_URL`, `CONTACT_PHONE`, `WHATSAPP_NUMBER` (digits with country code, e.g. 61400123456).

## 2. Free hosting (pick one)
- **Cloudflare Pages**: dash.cloudflare.com > Workers & Pages > Create > Pages > Upload assets. Upload the folder with `index.html`. You get a free `yourname.pages.dev` address.
- **Netlify Drop**: drag the folder onto https://app.netlify.com/drop. Free `*.netlify.app` address.
- **GitHub Pages**: put `index.html` in a public repository, then Settings > Pages.
You only redeploy when you change the code. Artworks you upload appear instantly.

## 3. Using the site as the artist
1. Click **Artist login** (top right), sign in, then **Dashboard**.
2. **+ Add artwork**: title, collection, description, price (leave blank for "Price on enquiry"), size, medium, availability, photo (JPEG/PNG/WebP, max 5 MB).
3. Each artwork page shows Enquire, Email, WhatsApp, Call and Instagram buttons, depending on which contact settings you filled in.
4. **View enquiries** in the dashboard lists every message with a Reply by email button.
5. The first artwork in each collection becomes that collection's cover photo automatically.

## Notes
- Indicative prices on the collection cards come from your business notes. Edit the `collections` list in `index.html` to change them.
- You are not emailed when an enquiry arrives; check the dashboard regularly.
- Free tiers have limits, and Supabase free projects pause after about a week of inactivity (just un-pause in the dashboard).
- The shipping, returns and privacy text is a starter only. Replace it with your real terms and check Australian Consumer Law and privacy obligations.
- A custom `.com.au` domain is optional and costs money.

## Troubleshooting
- Cannot log in: confirm the user, and check `OWNER_EMAIL` matches the SQL email exactly.
- Upload denied: re-run the SQL, and check you are signed in as the artist.
- Gallery empty: add an artwork, clear filters, check the browser console.
