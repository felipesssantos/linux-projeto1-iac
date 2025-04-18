#!/bin/bash

echo "==== Script Interativo para Configuração de Diretórios, Grupos e Usuários ===="

# Função para criar diretórios
criar_diretorios() {
    echo "Informe os diretórios a serem criados (separados por espaço):"
    read -a diretorios
    for dir in "${diretorios[@]}"; do
        mkdir -p "/$dir"
        echo "Diretório /$dir criado."
    done

    # Criando o diretório público
    if [ ! -d "/publico" ]; then
        mkdir -p /publico
        chmod 777 /publico
        echo "Diretório /publico criado com permissões públicas (777)."
    fi
}

# Função para criar grupos
criar_grupos() {
    echo "Informe os grupos de usuários a serem criados (separados por espaço):"
    read -a grupos
    for grupo in "${grupos[@]}"; do
        groupadd "$grupo"
        echo "Grupo $grupo criado."
    done
}

# Função para criar usuários
criar_usuarios() {
    echo "Quantos usuários você deseja criar?"
    read quantidade_usuarios
    for ((i = 1; i <= quantidade_usuarios; i++)); do
        echo "Informe o nome do usuário $i:"
        read usuario
        echo "Informe o grupo do usuário $usuario:"
        read grupo
        echo "Informe a senha do usuário $usuario:"
        read -s senha
        useradd -m -s /bin/bash -p "$(openssl passwd -crypt "$senha")" -G "$grupo" "$usuario"
        echo "Usuário $usuario criado no grupo $grupo."
    done
}

# Função para configurar permissões dos diretórios
configurar_permissoes() {
    echo "Agora vamos configurar as permissões dos diretórios."
    for dir in "${diretorios[@]}"; do
        echo "Informe o grupo que terá acesso ao diretório /$dir:"
        read grupo
        chown root:"$grupo" "/$dir"
        chmod 770 "/$dir"
        echo "Permissões configuradas para o diretório /$dir."
    done
    echo "O diretório público será configurado como acessível a todos."
    chmod 777 /publico
}

# Executando as funções
echo "==== Etapa 1: Criar Diretórios ===="
criar_diretorios

echo "==== Etapa 2: Criar Grupos ===="
criar_grupos

echo "==== Etapa 3: Criar Usuários ===="
criar_usuarios

echo "==== Etapa 4: Configurar Permissões ===="
configurar_permissoes

echo "==== Configuração Finalizada! ===="
