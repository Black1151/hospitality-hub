import styles from "./page.module.css";

type Item = {
  id: number;
  name: string;
  disabled?: boolean;
};

const items: Item[] = [
  { id: 1, name: "Hotel Booking" },
  { id: 2, name: "Room Service", disabled: true },
  { id: 3, name: "Event Management" },
];

export default function AdminPage() {
  return (
    <div className={styles.grid}>
      {items.map((item) => (
        <div
          key={item.id}
          className={`${styles.card} ${item.disabled ? styles.disabled : ""}`}
        >
          {item.name}
        </div>
      ))}
    </div>
  );
}
