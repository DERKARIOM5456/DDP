#!/bin/bash
GoAlias()
{
    grep go ~/.bashrc >> /dev/null
    if [ "$?" != 0 ] ; then
        echo "alias go='. go'" >> .bashrc
    fi

    # ajout de l' alias de go sur le shell zsh
    grep go ~/.zshrc >> /dev/null
    if [ "$?" != 0 ] ; then
        echo -e "\nalias go='. go'" >> ~/.zshrc
    fi
}

CreationBDD()
{
    if [ ! -d ".ddp" ]  ; then
        mkdir .ddp
    else
        cd .ddp/ # pour ce rendre dans le repertoire .ddp

        # Creation du sous repertoire ddp-projet dans le repertoire .ddp
        if [ ! -d "ddp-projet" ] ; then
            mkdir ddp-projet
        fi
    fi
    if [ ! -f "/usr/src/donnee.txt" ] ; then
        sudo touch /usr/src/donnee.txt /usr/src/log.txt
        sudo chmod 666 /usr/src/donnee.txt /usr/src/log.txt
        echo "0" > /usr/src/donnee.txt
    fi
}
Version()
{
    echo "DERKARIOM DEPOT DES PROJETS VERSION 2.2.1 :)"
}

#------------------------------------------------------------------
manuel()
{
    clear
    echo -e "\n\nLEGANT: OU(|) ET(&)\n"
    echo -e "\n\nddp -v | --version -> Pour afficher la version de ddp\n"
    echo -e "ddp -h | --help -> Pour afficher le manuel\n"
    echo -e "ddp -i | --information -> Pour afficher plus d' information\n"
    echo -e "ddp new | add -> Pour ajouter un nouveau projet\n"
    echo -e "ddp add <NomProjet> <CheminProjet>  -> Pour creer un depot du chemin de votre projet\n"
    echo -e "ddp add <NomProjet> <CheminProjet> <CodeCompiler> <CodeExecution>  -> Pour creer un depot de votre projet\n"
    echo -e "ddp log -> Pour lister les projets\n"
    echo -e "ddp del <NomProjet> -> Pour supprimer un projet\n"
    echo -e "ddp code <NomProjet> -> Pour ouvrir le projet avec vscode\n"
    echo -e "ddp run <NomProjet> -> Pour executer le projet\n"
    echo -e "ddp out <NomProjet> -> Pour compiler le projet\n"
    echo -e "ddp xout <NomProjet> -> Pour compiler et executer le projet\n"
    echo -e "ddp <NomProjet> -o [Executable] -> Pour compiler le projet\n"
    echo -e "ddp <NomProjet> -ox [Executable] -> Pour compiler et executer le projet\n"
    echo -e "ddp --os add <NomDepot> <CheminDepo> : Pour cree un depot de votre OS"
    echo -e "ddp --os backup <NomDepot> : Pour Sauvegarde votre OS"
    echo -e "ddp --os restor <NomDepot> : Pour restore votre OS"
    echo -e "ddp --os log : Pour afficher les depot system"
    echo -e "ddp --os drop <NomDepot> : Pour supprimer un depot system"
}

#-------------------------------------------------------------------
log()
{
    cat /usr/src/log.txt | hl -2y Depot -2y Alias -2y Chemin
}

#--------------------------------------------------------------------
info()
{
    echo "**************************************************************************"
    echo "# NOM: DERKARIOM DEPOT DES PROJETS (DDP)                                 #"
    echo "# VERSION: 2.2                                                           #"
    echo "# LICENCE: LIBRE                                                         #"
    echo "# CONSERNE: TOUTE PERSONNE AYANT DES CONNAISSANCES SUR UNIX              #"
    echo "# DATE:01/01/2023                                                        #"
    echo "# NATIONALITE: NIGERIENNE                                                #"
    echo "# AUTEUR: BACHIR ABDOUL KADER                                            #" 
    echo "# PROFESION: ETUDIANT A L' UNIVERSITE ABDOU MOUMOUNI DE NIAMEY           #" 
    echo "# CLUB: LES VISIONNAIRES                                                 #"
    echo "# PROJET: DERKARIOM                                                      #"
    echo "**************************************************************************"                     
}
Add0()
{
    # "new" est une variable qui stock le nom du projet
    # "chemin" est une variable qui stock le chemin du repertoire du projet
    # "compiler" est une variable qui stock le code de compilation du projet
    # "execution" est une variable qui stock le code d'execution du projet   
    # Saisie du nom du projet
    clear
    k=0
    until [ $k -lt 0 ]
    do
        read -p "NOM DU NOUVEAU PROJET : " new
        cd ~/.ddp/ddp-projet
        if [ -e "$new" ] ; then
            echo -e "\nERREUR -> ${new^^} : CE PROJET EXISTE !\n"
        else
            k=-1 # Cas d' arret de la boucle until
        fi
    done

    # Saisie du chemin absolu du projet
    k=0
    until [ $k -lt 0 ]
    do
        read -p "CHEMIN DU PROJET : " chemin
        cd "$chemin" 2> /dev/null
        if [ "$?" -eq 0 ] ; then
            k=-1  # Cas d' arret de la boucle until
        else
            echo -e "\n${chemin^^} EST INTROVABLE!\n"
        fi
    done

    # Saisie du code de compilation
    read -p "CODE DE CONPILATION : " compiler

    # Saisie du code d' execution
    read -p "CODE D' EXECUTION : " execution

    cd ~/.ddp/ddp-projet ; mkdir "$new" #Creation du basse de donne du project
    if [ "$?" -eq 0 ] ; then 
        echo "$chemin" > "$new"/chemin.txt
        if [ "$compiler" != "" ] ; then
            echo "$compiler" > "$new"/compiler.txt
        fi
        if [ "$execution" != "" ] ; then
            echo "$execution" > "$new"/execution.txt
        fi
    fi  
}
Supp()
{
    cd ~/.ddp/ddp-projet 2> /dev/null
    if [ "$?" -eq 0 ] ; then
        if [ -e "$1" ] ; then
            rm -r "$1"
            dplog drop "$1"
        else
            echo "ECHEC -> ${1^^} N' EXISTE PAS !"
        fi
    else
        echo "ECHEC !"
    fi
}
Code()
{
    cd ~/.ddp/ddp-projet/"$1" 2> /dev/null # pour ce rendre dans la base de donne du projet
    if [ "$?" -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ "$?" -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemin du projet dans une variable(rep)
        code "$rep" ; if [ "$?" -eq 0 ] ; then i=i+1 ; fi # pour ouvrire le project avec VSCODE
        if [ "$i" -eq 2 ] ; then
            echo "SUCCES :)"
        else
           echo "ECHEC !"
        fi
    else
        echo "ECHEC !" 
    fi
}
Open()
{
    cd ~/.ddp/ddp-projet/"$1" 2> /dev/null # pour ce rendre dans la base de donne du projet
    if [ "$?" -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ "$?" -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemin du projet dans une variable(rep)
        open "$rep" ; if [ "$?" -eq 0 ] ; then i=i+1 ; fi # pour ouvrire le project avec VSCODE
        if [ "$i" -eq 2 ] ; then
            echo "SUCCES :)"
        else
           echo "ECHEC !"
        fi
    else
        echo "ECHEC !" 
    fi
}
Out()
{
    cd ~/.ddp/ddp-projet/"$1" 2> /dev/null # pour ce rendre dans le repertoire de basse de donne du projet
    if [ $? -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemain du projet dans une variable(rep)
        compiler=$(cat compiler.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code de conpilation dans une variable(compiler)
        cd "$rep" 2> /dev/null ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour ce rendre dans le repertoire du projet
        $compiler # pour compiler le projet
        if [ $i -ne 3 ] ; then
            echo "ECHEC !"
        fi 
    else
        echo "ECHEC !"
    fi
}
Xout()
{
    cd ~/.ddp/ddp-projet/"$1" 2> /dev/null # pour ce rendre dans le repertoire de basse de donne du projet
    if [ $? -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemain du projet dans une variable(rep)
        compiler=$(cat compiler.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code de conpilation dans une variable(compiler)
        execution=$(cat execution.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code d' execution dans une variable(execution)
        cd "$rep" 2> /dev/null ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour ce rendre dans le repertoire du projet
        clear ; $compiler && $execution
        if [ "$i" -ne 4 ] ; then
            echo "ECHEC !"
        fi 
    else
        echo "ECHEC !"
    fi
}
Dgcc()
{
    cd ~/.ddp/ddp-projet/"$1" 2> /dev/null # pour ce rendre dans le repertoire de basse de donne du projet
    if [ $? -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemain du projet dans une variable(rep)
        compiler=$(cat compiler.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code de conpilation dans une variable(compiler)
        cd "$rep" 2> /dev/null ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour ce rendre dans le repertoire du projet
        $compiler # pour compiler le projet
        if [ $i -ne 3 ] ; then
            echo "ECHEC !"
        fi 
    else
        echo "ECHEC !"
    fi
}
XDgcc()
{
    cd ~/.ddp/ddp-projet/"$1" 2> /dev/null # pour ce rendre dans le repertoire de basse de donne du projet
    if [ $? -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemain du projet dans une variable(rep)
        compiler=$(cat compiler.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code de conpilation dans une variable(compiler)
        execution=$(cat execution.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code d' execution dans une variable(execution)
        cd "$rep" 2> /dev/null ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour ce rendre dans le repertoire du projet
        clear ; $compiler && $execution
        if [ $i -ne 4 ] ; then
            echo "ECHEC !"
        fi 
    else
        echo "ECHEC !"
    fi
}
Run()
{
    cd ~/.ddp/ddp-projet/"$1"/ 2> /dev/null # pour ce rendre dans la base de donne du projet
    if [ "$?" -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemain du projet dans une variable
        execution=$(cat execution.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code d' execution dans une variable
        cd "$rep" 2> /dev/null ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour ce rendre dans le repertoire du projet
        clear ; $execution # pour executer le projet
        if [ "$i" -ne 3 ] ; then
           echo "ECHEC !"
        fi
    else
        echo "ECHEC !"
    fi
}
Add2()
{
    if [ "$2" == "." ] ; then
        c=$repa
    else
        c=$2
    fi
    cd "$c" 2> /dev/null
    if [ "$?" -ne 0 ] ; then
        echo "${1^^} EST INTROUVABLE !"
    else
        i=0
        cd ~/.ddp/ddp-projet ; if [ $? -eq 0 ] ; then i=$i+1 ; fi
        mkdir "$1" 2> /dev/null ; if [ $? -eq 0 ] ; then i=$i+1 ; fi
        echo "$c" > $1/chemin.txt ; if [ $? -eq 0 ] ; then i=i+1 ; fi
        if [ $i -ne 3 ] ; then
            echo "ECHEC ! : CE PROJET EXISTE DEJA"
        else
            dplog add "$1" "$c"
        fi
    fi
}
Add4()
{
    if [ "$2" == "." ] ; then
        c=$repa
    else
        c=$2
    fi
    cd "$c" 2> /dev/null
    if [ "$?" -ne 0 ] ; then
        echo "$2 EST INTROUVABLE !"
    else
        i=0
        cd ~/.ddp/ddp-projet ; if [ $? -eq 0 ] ; then i=$i+1 ; fi
        mkdir "$1" ; if [ $? -eq 0 ] ; then i=$i+1 ; fi
        echo "$c" > $1/chemin.txt ; if [ $? -eq 0 ] ; then i=i+1 ; fi
        echo "$3" > $1/compiler.txt ; if [ $? -eq 0 ] ; then i=i+1 ; fi
        echo "$4" > $1/execution.txt ; if [ $? -eq 0 ] ; then i=i+1 ; fi
        if [ $i -ne 5 ] ; then
            echo "ECHEC !"
        fi
    fi
}
