#include 'totvs.ch'
#include 'topconn.ch'
#include 'tbiconn.ch'
/*/{Protheus.doc} RotinaCli
    (classe de recebmento de dados,
    trabalhando junto com classe
    para gravação SA1 ClienteInc.prw)
    @author Joao Couto
    @since 21/02/2024
    @version version
    /*/
User Function jClidados()
    RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
          
	    u_uClidados()

	RESET ENVIRONMENT

return

User Function uClidados()

    local oCliInc 
    oCliInc := RotinaCli():new_Cliente()
    oCliInc:exec_Rotina()
return
/*/{Protheus.doc} RotinaCli
    (classe de recebmento de dados,
    trabalhando junto com classe
    para gravação SA1 ClienteInc.prw)
    @author Joao Couto
    @since 21/02/2024
    @version version
    /*/
//Estrutura da classe e métodos
Class RotinaCli
    data cError
    data oCliente
    data oRet
    data oExeWs
    method new_Cliente() constructor
    method get_Cliente()
    method exec_WServiceCli()
    method exec_Rotina()
EndClass
//metodo construtor 
method new_Cliente() class RotinaCli
    ::cError    := ""
    ::oRet      := JsonObject():new()
    ::oCliente  := ClienteInc():new_ClienteSA1() //populando objeto com class/metodos de gravação
    ::oExeWs    := BuscaCLi():New_BuscaCli()

return
//metodo de chamado para os metodos abaixo
method exec_Rotina() class RotinaCli

    if(Empty(::cError))
        ::exec_WServiceCli()
    endif

    if(Empty(::cError))
        ::get_Cliente()
    endif
    
return
//metodo com retorno do APi
method exec_WServiceCli() class RotinaCli
    
    ::oRet := ::oExeWs:WsBuscaCli()

return ::oRet
//metodo que recebe os dados e executa o metodo de gravação
method get_Cliente() class RotinaCli
        //ALIAS
    ::oCliente:cFil            :=xFilial("SA1")
    ::oCliente:cCodigo         := ::oRet["Codigo"]  
    ::oCliente:cNome           := ::oRet["Nome"]
    ::oCliente:cLoja           := ::oRet["Loja"]
    ::oCliente:cPessoa         := ::oRet["Pessoa"]
    ::oCliente:cEndereco       := ::oRet["Endereco"]
    ::oCliente:cBairro         := ::oRet["Bairro"]
    ::oCliente:cNfantasia      := ::oRet["NFantasia"]
    ::oCliente:cTipo           := ::oRet["Tipo"]
    ::oCliente:cEstado         := ::oRet["Estado"]
    ::oCliente:nCep            := ::oRet["Cep"]
    ::oCliente:cMunicip        := ::oRet["Municipio"]
    ::oCliente:cRegiao         := ::oRet["Sucesso"]
    ::oCliente:cDescRegiao     := ::oRet["Sucesso"]
    ::oCliente:cNatureza       := ::oRet["Natureza"]
    ::oCliente:cCpfCnpj        := ::oRet["CPF/CNPJ"]

    ::oCliente:Incluir_Cli(3)
return
    