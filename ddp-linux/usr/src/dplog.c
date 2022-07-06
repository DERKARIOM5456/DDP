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
    FILE *log = fopen("/usr/src/log.txt","w");
    FILE *bdd = fopen("/usr/src/donnee.txt","w");
    cell *ptr;
    fprintf(bdd,"%d ",NbrDepot(dp));
    for(ptr=dp ; ptr!=NULL ; ptr=ptr->suivant)
    {
        fprintf(log,"\n");
        fprintf(log,"Depot  : %d\n" , ptr->num);
        fprintf(log,"Nom    : %s\n" , ptr->nom);
        fprintf(log,"Chemin : %s\n" , ptr->chemin);
        fprintf(log,"\n\n");
        fprintf(bdd,"%s %s ",ptr->nom,ptr->chemin);
    }
    fclose(log);
    fclose(bdd);
}
Depot ChargeFichier()
{
    Depot dp = DepotVide();
    cell *nouv,*ptr;
    int num;
    char *nom = (char*)malloc(sizeof(char)*20);
    char *chemin = (char*)malloc(sizeof(char)*50);
    FILE *fp = fopen("/usr/src/donnee.txt","r");
    int i,nbr;
    fscanf(fp,"%d",&nbr);
    for(i=nbr;i>0;i--)
    {
        nouv = (cell*)malloc(sizeof(cell));
        nouv->nom=(char*)malloc(sizeof(char)*20);
        nouv->chemin=(char*)malloc(sizeof(char)*50);
        fscanf(fp,"%s %s",nouv->nom,nouv->chemin);
        nouv->num = i;
        if(i==nbr)
            dp = nouv;
        else
        {
            ptr = dp;
            while(ptr->suivant != NULL)
                ptr = ptr->suivant;
            ptr->suivant = nouv;
        }
    }
    return dp; 
}
void Affichier(Depot dp)
{
    cell *ptr;
    ptr = dp;
    while(ptr!=NULL)
    {
        printf("\nCode : %d\n",ptr->num);
        printf("Nom : %s\n",ptr->nom);
        printf("Chemin : %s\n",ptr->chemin);
        ptr = ptr->suivant;
    }
}
Depot DropDepot(Depot dp , char *nom)
{
    cell *ptr,*q;
    ptr = dp;
    if (strcmp(dp->nom,nom) == 0)
    {
        dp = dp->suivant;
        free(ptr);
    }
    else
    {
        q = ptr->suivant;
        while(q != NULL && strcmp(q->nom,nom)!=0)
        {
            ptr = ptr->suivant;
            q = q->suivant;
        }
        if(ptr != NULL)
        {
            ptr->suivant = q->suivant;
            free(q);
        }
        else
            fprintf(stderr,"Ce depot n'existe pas !\n");
    }
    return dp;
}
int main(int argc , char ** argv)
{
    Depot dp = DepotVide();
    dp = ChargeFichier(dp);
   if ((strcmp(argv[1],"add")==0) && (argc == 4))
    {
        dp=AddDepot(dp,argv[2],argv[3]);
        Sauvegarder(dp);
    }
    if ((strcmp(argv[1],"drop")==0) && (argc == 3))
    {
        dp=DropDepot(dp,argv[2]);
        Sauvegarder(dp);
    }
}