package data_structures.interfaces;

public interface SList<E> {
    void add(E e);
    E get(int index);
    E remove(int index);
    int size();
}