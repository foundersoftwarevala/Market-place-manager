CREATE TABLE public.home_hero_slides (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug text UNIQUE NOT NULL,
  kicker text NOT NULL,
  title text NOT NULL,
  subtitle text NOT NULL,
  highlight text NOT NULL DEFAULT '',
  cta_primary text NOT NULL,
  cta_secondary text NOT NULL,
  cta_link text NOT NULL DEFAULT '/demos',
  gradient text NOT NULL,
  icon_name text NOT NULL,
  accent text NOT NULL,
  position int NOT NULL DEFAULT 0,
  visible boolean NOT NULL DEFAULT true,
  published_at timestamptz,
  unpublish_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.home_hero_slides TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON public.home_hero_slides TO authenticated;
GRANT ALL ON public.home_hero_slides TO service_role;
ALTER TABLE public.home_hero_slides ENABLE ROW LEVEL SECURITY;
CREATE POLICY "home_hero public read" ON public.home_hero_slides FOR SELECT TO anon, authenticated
  USING (visible = true AND (published_at IS NULL OR published_at <= now()) AND (unpublish_at IS NULL OR unpublish_at > now()));
CREATE POLICY "home_hero admin read all" ON public.home_hero_slides FOR SELECT TO authenticated USING (public.has_role(auth.uid(),'admin') OR public.has_role(auth.uid(),'boss'));
CREATE POLICY "home_hero admin insert" ON public.home_hero_slides FOR INSERT TO authenticated WITH CHECK (public.has_role(auth.uid(),'admin') OR public.has_role(auth.uid(),'boss'));
CREATE POLICY "home_hero admin update" ON public.home_hero_slides FOR UPDATE TO authenticated USING (public.has_role(auth.uid(),'admin') OR public.has_role(auth.uid(),'boss')) WITH CHECK (public.has_role(auth.uid(),'admin') OR public.has_role(auth.uid(),'boss'));
CREATE POLICY "home_hero admin delete" ON public.home_hero_slides FOR DELETE TO authenticated USING (public.has_role(auth.uid(),'admin') OR public.has_role(auth.uid(),'boss'));
CREATE TRIGGER trg_home_hero_updated BEFORE UPDATE ON public.home_hero_slides FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TABLE public.site_notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  body text NOT NULL DEFAULT '',
  kind text NOT NULL DEFAULT 'info',
  link_url text,
  is_published boolean NOT NULL DEFAULT true,
  published_at timestamptz NOT NULL DEFAULT now(),
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.site_notifications TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.site_notifications TO authenticated;
GRANT ALL ON public.site_notifications TO service_role;
ALTER TABLE public.site_notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Published notifications are public" ON public.site_notifications FOR SELECT USING (is_published = true);
CREATE POLICY "Admins manage notifications" ON public.site_notifications FOR ALL TO authenticated
  USING (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(),'boss')) WITH CHECK (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(),'boss'));
CREATE TRIGGER trg_site_notifications_updated BEFORE UPDATE ON public.site_notifications FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
INSERT INTO public.site_notifications (title, body, kind, link_url, sort_order) VALUES
  ('Lifetime deal live — $249', '40% OFF on the full catalog. One-time payment, lifetime access, full source code.', 'promo', '/#pricing', 1),
  ('2-hour delivery guarantee', 'Source code, database and deployment guide delivered within 2 hours of purchase.', 'info', null, 2),
  ('20 live demos available', 'Try any product before you buy — 20 fully hosted live demos across master categories.', 'info', null, 3),
  ('Vendor & reseller applications open', 'Apply as Vendor, Reseller, Author, Affiliate or Franchise partner.', 'update', '/careers?type=vendor', 4),
  ('1 year free support included', 'Every purchase includes 12 months of updates and technical support.', 'info', null, 5);

CREATE TABLE public.site_settings (
  key text PRIMARY KEY,
  value jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.site_settings TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.site_settings TO authenticated;
GRANT ALL ON public.site_settings TO service_role;
ALTER TABLE public.site_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "site_settings public read" ON public.site_settings FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "site_settings admin write" ON public.site_settings FOR ALL TO authenticated
  USING (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(),'boss')) WITH CHECK (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(),'boss'));
CREATE TRIGGER trg_site_settings_updated BEFORE UPDATE ON public.site_settings FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TABLE public.announcements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  badge text NOT NULL DEFAULT '',
  text text NOT NULL DEFAULT '',
  icon_name text NOT NULL DEFAULT 'PartyPopper',
  gradient text NOT NULL DEFAULT 'from-amber-500 via-orange-500 to-red-500',
  position integer NOT NULL DEFAULT 0,
  visible boolean NOT NULL DEFAULT true,
  starts_at timestamptz,
  ends_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.announcements TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON public.announcements TO authenticated;
GRANT ALL ON public.announcements TO service_role;
ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "announcements public read" ON public.announcements FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "announcements admin write" ON public.announcements FOR ALL TO authenticated
  USING (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(),'boss')) WITH CHECK (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(),'boss'));
CREATE TRIGGER trg_announcements_updated BEFORE UPDATE ON public.announcements FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TABLE public.feature_strip_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  label text NOT NULL,
  icon_name text NOT NULL DEFAULT 'ShieldCheck',
  color_class text NOT NULL DEFAULT 'text-cyan-300',
  position integer NOT NULL DEFAULT 0,
  visible boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.feature_strip_items TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON public.feature_strip_items TO authenticated;
GRANT ALL ON public.feature_strip_items TO service_role;
ALTER TABLE public.feature_strip_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "feature_strip public read" ON public.feature_strip_items FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "feature_strip admin write" ON public.feature_strip_items FOR ALL TO authenticated
  USING (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(),'boss')) WITH CHECK (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(),'boss'));
CREATE TRIGGER trg_feature_strip_updated BEFORE UPDATE ON public.feature_strip_items FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TABLE public.homepage_sections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  section_key text NOT NULL UNIQUE,
  label text NOT NULL,
  position integer NOT NULL DEFAULT 0,
  visible boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.homepage_sections TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON public.homepage_sections TO authenticated;
GRANT ALL ON public.homepage_sections TO service_role;
ALTER TABLE public.homepage_sections ENABLE ROW LEVEL SECURITY;
CREATE POLICY "homepage_sections public read" ON public.homepage_sections FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "homepage_sections admin write" ON public.homepage_sections FOR ALL TO authenticated
  USING (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(),'boss')) WITH CHECK (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(),'boss'));
CREATE TRIGGER trg_homepage_sections_updated BEFORE UPDATE ON public.homepage_sections FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

INSERT INTO public.site_settings (key, value) VALUES
  ('brand', '{"name":"Software Vala","tagline":"- The Name of Trust"}'::jsonb),
  ('header_badges', '{"lifetime_deal":"$249 Lifetime Deal","discount":"40% OFF","show_manager_link":true,"show_boss_portal":true}'::jsonb),
  ('footer', '{"copyright":"© 2024 Software Vala - The Name of Trust. All rights reserved.","tagline":"55 Master Categories • Software Solutions • 20 Live Demos Ready"}'::jsonb);

INSERT INTO public.announcements (title, badge, text, icon_name, gradient, position) VALUES
  ('🎉 Mega Software Sale —', 'Flat 40% OFF', 'Lifetime access on all products!', 'PartyPopper', 'from-amber-500 via-orange-500 to-red-500', 0),
  ('⚡ Instant Deployment —', '2-Hour Delivery', 'Source code + setup delivered same day.', 'Truck', 'from-amber-500 via-orange-500 to-red-500', 1),
  ('🔒 Buyer Protection —', 'No Advance Payment', 'Pay only after live demo approval.', 'ShieldCheck', 'from-amber-500 via-orange-500 to-red-500', 2),
  ('🌍 Global Support —', '24×7 Live Help', 'Human + AI assistance in 12 languages.', 'Headphones', 'from-amber-500 via-orange-500 to-red-500', 3);

INSERT INTO public.feature_strip_items (label, icon_name, color_class, position) VALUES
  ('No Advance Payment', 'ShieldCheck', 'text-emerald-300', 0),
  ('2-Hour Delivery', 'Clock', 'text-cyan-300', 1),
  ('No Hidden Charges', 'BadgeCheck', 'text-amber-300', 2),
  ('Trademark Protected', 'Lock', 'text-rose-300', 3),
  ('204+ Solutions', 'Boxes', 'text-violet-300', 4);

INSERT INTO public.homepage_sections (section_key, label, position, visible) VALUES
  ('hero', 'Hero Carousel', 0, true),
  ('feature_strip', 'Feature Strip', 10, true),
  ('categories', 'Category Slider', 20, true),
  ('festive_banner', 'Festive Banner', 30, true),
  ('featured', 'Featured Products', 40, true),
  ('trending', 'Trending', 50, true),
  ('best_sellers', 'Best Sellers', 60, true),
  ('new_releases', 'New Releases', 70, true),
  ('ai_products', 'AI Products', 80, true),
  ('vendors', 'Top Vendors', 90, true);