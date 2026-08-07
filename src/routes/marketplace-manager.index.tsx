import { createFileRoute } from "@tanstack/react-router";
import { MarketplaceManagerModule } from "@/components/marketplace-manager/MarketplaceManagerModule";

export const Route = createFileRoute("/marketplace-manager/")({
  ssr: false,
  head: () => ({
    meta: [
      { title: "Marketplace Manager — Software Vala" },
      { name: "description", content: "Manage the global marketplace, storefront, campaigns, and integrations." },
      { name: "robots", content: "noindex" },
    ],
  }),
  component: MarketplaceManagerModule,
});
