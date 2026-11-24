#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct {
    char denumirea[50];
    char adresa[100];
    char telefonul[20];
    int categoria;     
    int numarLocuri;
} Hotel;


void curataBuffer() {
    int c;
    while ((c = getchar()) != '\n' && c != EOF);
}


void citesteUnHotel(Hotel *h) {
    printf("  Denumirea: ");
    fgets(h->denumirea, sizeof(h->denumirea), stdin);
    h->denumirea[strcspn(h->denumirea, "\n")] = '\0';

    printf("  Adresa: ");
    fgets(h->adresa, sizeof(h->adresa), stdin);
    h->adresa[strcspn(h->adresa, "\n")] = '\0';

    printf("  Telefonul: ");
    fgets(h->telefonul, sizeof(h->telefonul), stdin);
    h->telefonul[strcspn(h->telefonul, "\n")] = '\0';

    printf("  Categoria (stele): ");
    scanf("%d", &h->categoria);

    printf("  Numarul de locuri: ");
    scanf("%d", &h->numarLocuri);
    curataBuffer();
}


Hotel* alocaMemorie(int *n) {
    printf("Introdu numarul initial de hoteluri: ");
    scanf("%d", n);
    curataBuffer();

    if (*n <= 0) {
        printf("Numar invalid!\n");
        *n = 0;
        return NULL;
    }

    Hotel *tablou = (Hotel*)malloc((*n) * sizeof(Hotel));
    if (tablou == NULL) {
        printf("Eroare la alocarea memoriei!\n");
        exit(1);
    }
    printf("Memorie alocata cu succes pentru %d elemente.\n", *n);
    return tablou;
}


void introduceElemente(Hotel *tablou, int n) {
    if (tablou == NULL || n == 0) {
        printf("Mai intai alocati memorie (Optiunea 1)!\n");
        return;
    }
    for (int i = 0; i < n; i++) {
        printf("\n--- Hotelul %d ---\n", i + 1);
        citesteUnHotel(&tablou[i]);
    }
}


void afiseazaElemente(const Hotel *tablou, int n) {
    if (tablou == NULL || n == 0) {
        printf("Tabloul este gol sau memoria nu a fost alocata!\n");
        return;
    }
    printf("\n%-4s | %-20s | %-25s | %-15s | %-5s | %-6s\n", 
           "Nr.", "Denumirea", "Adresa", "Telefon", "Cat.", "Locuri");
    printf("---------------------------------------------------------------------------------------\n");
    for (int i = 0; i < n; i++) {
        printf("%-4d | %-20s | %-25s | %-15s | %-5d | %-6d\n",
               i + 1,
               tablou[i].denumirea,
               tablou[i].adresa,
               tablou[i].telefonul,
               tablou[i].categoria,
               tablou[i].numarLocuri);
    }
}

Hotel* adaugaElement(Hotel *tablou, int *n) {
    Hotel *temp = (Hotel*)realloc(tablou, (*n + 1) * sizeof(Hotel));
    if (temp == NULL) {
        printf("Eroare la realocarea memoriei!\n");
        return tablou;
    }
    tablou = temp;
    printf("\n--- Introduceti datele noului hotel ---\n");
    citesteUnHotel(&tablou[*n]);
    (*n)++;
    printf("Hotel adaugat cu succes!\n");
    return tablou;
}


void modificaElement(Hotel *tablou, int n) {
    if (tablou == NULL || n == 0) {
        printf("Tabloul este gol!\n");
        return;
    }
    int index;
    printf("Introdu numarul de ordine al hotelului de modificat (1 - %d): ", n);
    scanf("%d", &index);
    curataBuffer();

    if (index < 1 || index > n) {
        printf("Pozitie invalida!\n");
        return;
    }
    printf("--- Introduceti noile date pentru hotelul %d ---\n", index);
    citesteUnHotel(&tablou[index - 1]);
    printf("Element modificat cu succes!\n");
}


void cautaElement(const Hotel *tablou, int n) {
    if (tablou == NULL || n == 0) {
        printf("Tabloul este gol!\n");
        return;
    }
    char denumireCautata[50];
    printf("Introdu denumirea hotelului cautat: ");
    fgets(denumireCautata, sizeof(denumireCautata), stdin);
    denumireCautata[strcspn(denumireCautata, "\n")] = '\0';

    int gasit = 0;
    for (int i = 0; i < n; i++) {
        if (strcmp(tablou[i].denumirea, denumireCautata) == 0) {
            printf("\nHotel gasit pe pozitia %d:\n", i + 1);
            printf("  Denumire: %s | Adresa: %s | Telefon: %s | Categoria: %d* | Locuri: %d\n",
                   tablou[i].denumirea, tablou[i].adresa, tablou[i].telefonul,
                   tablou[i].categoria, tablou[i].numarLocuri);
            gasit = 1;
        }
    }
    if (!gasit) {
        printf("Hotelul \"%s\" nu a fost gasit.\n", denumireCautata);
    }
}

void sorteazaTablou(Hotel *tablou, int n) {
    if (tablou == NULL || n < 2) {
        printf("Nu sunt suficiente elemente pentru sortare.\n");
        return;
    }
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (tablou[j].numarLocuri > tablou[j + 1].numarLocuri) {
                Hotel aux = tablou[j];
                tablou[j] = tablou[j + 1];
                tablou[j + 1] = aux;
            }
        }
    }
    printf("Tabloul a fost sortat crescator dupa numarul de locuri.\n");
}

// 8. Eliminarea elementului indicat din tablou
Hotel* eliminaElement(Hotel *tablou, int *n) {
    if (tablou == NULL || *n == 0) {
        printf("Tabloul este gol!\n");
        return tablou;
    }
    int index;
    printf("Introdu numarul de ordine al hotelului de sters (1 - %d): ", *n);
    scanf("%d", &index);
    curataBuffer();

    if (index < 1 || index > *n) {
        printf("Pozitie invalida!\n");
        return tablou;
    }


    for (int i = index - 1; i < *n - 1; i++) {
        tablou[i] = tablou[i + 1];
    }
    (*n)--;

    if (*n == 0) {
        free(tablou);
        printf("Ultimul element a fost sters. Memoria a fost eliberata.\n");
        return NULL;
    }

    Hotel *temp = (Hotel*)realloc(tablou, (*n) * sizeof(Hotel));
    if (temp != NULL) {
        tablou = temp;
    }
    printf("Element sters cu succes!\n");
    return tablou;
}


Hotel* elibereazaMemorie(Hotel *tablou, int *n) {
    if (tablou != NULL) {
        free(tablou);
        tablou = NULL;
        *n = 0;
        printf("Memoria a fost eliberata cu succes.\n");
    } else {
        printf("Memoria este deja goala.\n");
    }
    return NULL;
}

int main() {
    Hotel *hoteluri = NULL;
    int n = 0;
    int optiune;

    do {
        printf("\n================ MENIU HOTELURI ================\n");
        printf("1. Alocarea dinamica a memoriei pentru tabloul de structuri\n");
        printf("2. Introducerea elementelor tabloului de la tastatura\n");
        printf("3. Afisarea elementelor tabloului la ecran\n");
        printf("4. Adaugarea unui element nou la sfarsit\n");
        printf("5. Modificarea elementului tabloului\n");
        printf("6. Cautarea elementului tabloului\n");
        printf("7. Sortarea tabloului\n");
        printf("8. Eliminarea elementului indicat din tablou\n");
        printf("9. Eliberarea memoriei alocate pentru tablou\n");
        printf("0. Iesire din program\n");
        printf("================================================\n");
        printf("Alege optiunea: ");
        scanf("%d", &optiune);
        curataBuffer();

        switch (optiune) {
            case 1:
                if (hoteluri != NULL) free(hoteluri);
                hoteluri = alocaMemorie(&n);
                break;
            case 2:
                introduceElemente(hoteluri, n);
                break;
            case 3:
                afiseazaElemente(hoteluri, n);
                break;
            case 4:
                hoteluri = adaugaElement(hoteluri, &n);
                break;
            case 5:
                modificaElement(hoteluri, n);
                break;
            case 6:
                cautaElement(hoteluri, n);
                break;
            case 7:
                sorteazaTablou(hoteluri, n);
                break;
            case 8:
                hoteluri = eliminaElement(hoteluri, &n);
                break;
            case 9:
                hoteluri = elibereazaMemorie(hoteluri, &n);
                break;
            case 0:
                if (hoteluri != NULL) free(hoteluri);
                printf("Iesire din program...\n");
                break;
            default:
                printf("Optiune invalida! Incearca din nou.\n");
        }
    } while (optiune != 0);

    return 0;
}
