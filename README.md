# Pawna Escape — Company Team Getaway

A responsive static website for the company Pawna Lake getaway. It includes:

- A split-screen Villa Stay vs Lakeside Camping comparison with a black/yellow divider
- A shortlist of named villa options and official property links
- The full three-day / two-night experience and itinerary
- The Bhayandar → Dadar Western → Dadar Central → Lonavala → Pawna route
- A shared team poll for Villa vs Camping and individual villa preferences
- Activity ideas, meals, logistics and safety notes

The public website intentionally contains no calendar dates or monetary amounts.

## Deploy on Vercel (recommended)

This project uses a tiny Vercel Function at `api/config.js` to read the Supabase browser-safe credentials at runtime. You do **not** need a custom build command or a generated `config.js` file.

1. Push the contents of this project folder to the connected GitHub repository. Make sure `api/config.js` is at the repository root inside the `api` folder, alongside `index.html`.
2. In Vercel → Project → Settings → Environment Variables, add:
   - `SUPABASE_URL` = your Supabase Project URL (usually `https://<project-ref>.supabase.co`)
   - `SUPABASE_ANON_KEY` = your Supabase publishable key (`sb_publishable_...`) or legacy anon key.
3. Enable the variables for **Production** and **Preview** (or all environments).
4. In Vercel → Project → Settings → Build and Deployment, use **Other** as Framework Preset, leave Build Command empty, and use `.` as Output Directory (or leave the default root output). Remove any old custom build command that writes `config.js`.
5. Save the settings and trigger a new deployment after saving the environment variables. Vercel applies changed variables to new deployments, not already-created deployments.
6. Test `https://YOUR-DOMAIN/api/config.js`. It should return a `window.PAWNA_CONFIG` object with a non-empty `supabaseUrl` and `supabaseAnonKey`. Do not paste the returned key into public chats; it is a public browser key, but still belongs to your project.
7. Open the website. The voting status should display **Shared team voting**. Test by submitting a vote and opening the site in another browser/device.

### Supabase setup

1. Create a Supabase project.
2. In Supabase → SQL Editor, run the full contents of `supabase/voting.sql`. This version includes the `pawna-camping` choice.
3. Copy the Project URL and the public publishable/anon key into Vercel as described above.

Only expose the publishable/anon key. **Never** use the Supabase `service_role` or secret key in browser code or in this config endpoint. The SQL keeps the vote table private and exposes only aggregate counts and vote-submission functions.

### Troubleshooting

- If `/api/config.js` returns empty strings, the Vercel environment variables are missing from the deployment's environment scope, have incorrect names, or the project has not been redeployed since they were added.
- If the endpoint returns populated values but the page still says Preview mode, open browser DevTools → Console and Network and check whether the Supabase JS CDN script or `/api/config.js` failed to load.
- If the page says Shared team voting but shows a Supabase/RPC error, run `supabase/voting.sql` in the correct Supabase project and confirm the Vercel URL/key belong to that same project.
- Votes made earlier in Preview mode are stored only in that browser and will not migrate to Supabase. Submit the preference again after Shared team voting is active.

## Deploy on Coolify with Docker

The same browser path `/api/config.js` is served by Nginx in the Docker image.

1. Push this folder to GitHub and create an Application in Coolify using the Dockerfile build pack.
2. Expose container port `80`.
3. Add `SUPABASE_URL` and `SUPABASE_ANON_KEY` as runtime environment variables.
4. Deploy. The container entrypoint writes `/api/config.js` from those environment variables before Nginx starts.
5. Test `/api/config.js` on the deployed domain and confirm the website reports Shared team voting.

## Local preview

Open `index.html` or run `python3 -m http.server 8080`. Without the Vercel Function or Docker-generated `/api/config.js`, the local page intentionally falls back to browser-only preview voting.

## Notes

- Photos are loaded from external property and activity websites, so visitors need internet access. Confirm image usage rights before public/commercial use.
- Villa capacity, room layout, lake access, campsite availability and inclusions must be reconfirmed with the property/operator before selection.
- The train section intentionally avoids train times. Verify the service, operating day, Dadar stop and Lonavala arrival on IRCTC/NTES after travel dates are chosen.
