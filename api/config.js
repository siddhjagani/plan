// Vercel runtime function: expose only the Supabase browser-safe project URL and public key.
// Never add a service-role or secret key here.
module.exports = function handler(req, res) {
  res.setHeader('Content-Type', 'application/javascript; charset=utf-8');
  res.setHeader('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0');
  res.setHeader('X-Content-Type-Options', 'nosniff');

  if (req.method !== 'GET') {
    res.setHeader('Allow', 'GET');
    return res.status(405).send('Method not allowed');
  }

  const config = {
    supabaseUrl: process.env.SUPABASE_URL || '',
    supabaseAnonKey: process.env.SUPABASE_ANON_KEY || ''
  };

  return res.status(200).send(`window.PAWNA_CONFIG = ${JSON.stringify(config)};\n`);
};
