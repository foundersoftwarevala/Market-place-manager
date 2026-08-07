import { useSyncExternalStore } from "react";

export type AppNotification = {
  id: string;
  title: string;
  detail: string;
  tone: "info" | "success" | "warning";
  read: boolean;
};

let items: AppNotification[] = [
  { id: "n1", title: "Deployment succeeded", detail: "Storefront build 214 is live.", tone: "success", read: false },
  { id: "n2", title: "3 products await approval", detail: "Author submissions in moderation queue.", tone: "warning", read: false },
  { id: "n3", title: "SEO audit ready", detail: "New crawl report generated for 42 pages.", tone: "info", read: false },
];

const listeners = new Set<() => void>();
const emit = () => listeners.forEach((l) => l());

export function markAllRead() {
  items = items.map((n) => ({ ...n, read: true }));
  emit();
}

export function markRead(id: string) {
  items = items.map((n) => (n.id === id ? { ...n, read: true } : n));
  emit();
}

export function useNotifications() {
  return useSyncExternalStore(
    (cb) => {
      listeners.add(cb);
      return () => listeners.delete(cb);
    },
    () => items,
    () => items,
  );
}

export function useUnreadCount() {
  return useNotifications().filter((n) => !n.read).length;
}
