#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct cell
{
    int num;
    char *nom;
    char *chemin;
    struct cell *suivant;
}*Depot,cell;
Depot DepotVide()
{
    Depot dp;
    dp = NULL;
    return dp;
}
int NbrDepot(Depot dp)
{
    cell *ptr;
    int nbr=0;
    ptr = dp;
    while (ptr!=NULL)
    {
        nbr++;
        ptr = ptr->suivant;       
    }
    return nbr;
}
Depot AddDepot(Depot dp , char* nom , char *chemin)
{
    cell *nouv = (cell*)malloc(sizeof(cell));
    nouv->nom = (char*)malloc(sizeof(char)*20);
    nouv->chemin = (char*)malloc(sizeof(char)*50);
    nouv->num = NbrDepot(dp)+1 ;
    strcpy(nouv->nom,nom);
    strcpy(nouv->chemin,chemin);
    nouv->suivant = dp;
    return nouv;
}
void Sauvegarder(Depot dp)
{
    FILE *fp = fopen("fichier.txt","w");
    FILE *fig = fopen("fig.txt","w");
    cell *ptr;
    fprintf(fig,"%d ",NbrDepot(dp));
    for(ptr=dp ; ptr!=NULL ; ptr=ptr->suivant)
    {
        fprintf(fp,"\n");
        fprintf(fp,"Numero : %d\n" , ptr->num);
        fprintf(fp,"Nom : %s\n" , ptr->nom);
        fprintf(fp,"Chemin : %s\n" , ptr->chemin);
        fprintf(fp,"\n--------------------------------------\n");
        fprintf(fig,"%d %s %s",ptr->num,ptr->nom,ptr->chemin);
    }
    fclose(fp);
}
Depot ChargeFichier()
{
    Depot dp;
    dp = DepotVide();
    FILE *fp = fopen("fig.txt","r");
    int i,nbr;
    while (!feof(fp))
    {
        fscanf(fp,"%d %s %s",&dp->num,dp->nom,dp->chemin);
    }
    
}
int main()
{
    Depot dp;
    dp = DepotVide();
    dp = AddDepot(dp,"ddp","/homme/projet/ddp");
    dp = AddDepot(dp,"guil","/homme/projet/guil");
    dp = AddDepot(dp,"struct","/homme/projet/struct");
    printf("%d\n",NbrDepot(dp));
    Sauvegarder(dp);
}