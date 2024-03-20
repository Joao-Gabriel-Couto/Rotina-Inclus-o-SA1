#include 'totvs.ch'
#include 'topconn.ch'
#include 'tbiconn.ch'

/*/{Protheus.doc} classe 
para incluir clientes
@author Joao Couto
@since 15/02/2024
@version 1.0
/*/
//Atributos e metodos 
class ClienteInc 

    data OPC_INCLUIR
	data OPC_ALTERAR
	data OPC_EXCLUIR
    data cErro

    data cFil
    data cCodigo
    data cLoja
    data cNome
    data cPessoa
    data cEndereco
    data cNfantasia
    data cBairro
    data cTipo
    data cEstado
    data nCep
    data cMunicip
    data cRegiao
    data cDescRegiao
    data cNatureza
    data cCpfCnpj
    
    method  new_ClienteSA1() constructor
    method  Incluir_Cli()     
    method  DefCamp_WAlias()
endclass
/*/{Protheus.doc} Metodo
Construtor
@author Joao Couto
@since 15/02/2024
@version 1.0
/*/
method new_ClienteSA1() class ClienteInc

    ::OPC_INCLUIR	:= 3
	::OPC_ALTERAR	:= 4
	::OPC_EXCLUIR	:= 5

return
/*/{Protheus.doc} Mï¿½todo 
de definiï¿½ï¿½o dos valores das variaveis com o Alias SA1 posicionado
@author Joao Couto
@since 15/02/2024
@version 1.0
/*/
method DefCamp_WAlias() class ClienteInc

    ::cFil          := SA1->A1_FILIAL
    ::cCodigo       := SA1->A1_COD
    ::cLoja         := SA1->A1_LOJA
    ::cNome         := SA1->A1_NOME
    ::cPessoa       := SA1->A1_PESSOA
    ::cEndereco     := SA1->A1_END    
    ::cNfantasia    := SA1->A1_NREDUZ    
    ::cBairro       := SA1->A1_BAIRRO
    ::cTipo         := SA1->A1_TIPO
    ::cEstado       := SA1->A1_EST
    ::nCep          := SA1->A1_CEP
    ::cMunicip      := SA1->A1_MUN    
    ::cRegiao       := SA1->A1_REGIAO    
    ::cNatureza     := SA1->A1_NATUREZ    
    ::cCpfCnpj      := SA1->A1_CGC
return
/*/{Protheus.doc} Método 
de manipulicao do cliente
@author Joao Couto
@since 15/02/2024
@version 1.0
/*/

method Incluir_Cli(nOpc) class ClienteInc
    local lRet       := .T.
    local aValSA1    := {}
    local aResultPro := {}
    default nOpc := ::OPC_INCLUIR

	private lMsHelpAuto     := .T. // Se .T. direciona as mensagens de help para o arq. de log
	private lMsErroAuto     := .F.
	private lAutoErrNoFile  := .F. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros
    
   
    if(!Empty(::cFil))
			AAdd(aValSA1,{"A1_FILIAL" 	 , ::cFil		, nil})
	endIf
    
    if(!Empty(::cCodigo))
			AAdd(aValSA1,{"A1_COD" 	 , ::cCodigo		, nil})
	endIf

     if(!Empty(::cLoja))
			AAdd(aValSA1,{"A1_LOJA" 	 , ::cLoja		, nil})
	endIf
    
     if(!Empty(::cNome))
			AAdd(aValSA1,{"A1_NOME" 	 , ::cNome		, nil})
	endIf

    
     if(!Empty(::cPessoa))
			AAdd(aValSA1,{"A1_PESSOA" 	 , ::cPessoa		, nil})
	endIf

     if(!Empty(::cEndereco))
			AAdd(aValSA1,{"A1_END" 	 , ::cEndereco		, nil})
	endIf

    if(!Empty(::cNfantasia))
			AAdd(aValSA1,{"A1_NREDUZ" 	 , ::cNfantasia		, nil})
	endIf

     if(!Empty(::cBairro))
			AAdd(aValSA1,{"A1_BAIRRO" 	 , ::cBairro		, nil})
	endIf

    if(!Empty(::cTipo))
			AAdd(aValSA1,{"A1_TIPO" 	 , ::cTipo		, nil})
	endIf

    if(!Empty(::cEstado))
			AAdd(aValSA1,{"A1_EST" 	 , ::cEstado		, nil})
	endIf

    if(!Empty(::nCep))
			AAdd(aValSA1,{"A1_CEP" 	 , ::nCep		, nil})
	endIf

    if(!Empty(::cMunicip))
			AAdd(aValSA1,{"A1_MUN" 	 , ::cMunicip		, nil})
	endIf

    if(!Empty(::cRegiao))
			AAdd(aValSA1,{"A1_REGIAO" 	 , ::cRegiao		, nil})
	endIf

    if(!Empty(::cNatureza))
			AAdd(aValSA1,{"A1_NATUREZ" 	 , ::cNatureza		, nil})
	endIf
  
    
     //Conferir se o cliente ja existe, consulta CNPJ/CPF
    DbSelectArea("SA1")
    DbSetOrder(3)
    if (nOpc == ::OPC_INCLUIR)
        SA1->(!DbSeek(xFilial("SA1")+::cCpfCnpj))
        lRet := .T.
    else
        lRet :=.F.
        Msginfo("O CPF/CNPJ informado jï¿½ estï¿½ cadastrado como cliente")
    endif

    aValSA1 := FwVetByDic( aValSA1, "SA1" )
    //execução da  gravação no banco via MsExcAuto
        MsExecAuto({|x,y| MATA030(x,y)}, aValSA1, nOpc)
        IF lMsErroAuto
            aResult := MostraErro()
            
        else
            aResultPro := { .T. , "Cliente incluï¿½do com sucesso", SA1->( Recno() ) }	    
        ENDIF
 
        
   
    

return aResultPro
