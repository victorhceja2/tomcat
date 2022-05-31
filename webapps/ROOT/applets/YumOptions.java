/*
##########################################################################################################
# Nombre Archivo  : YumOptions.java
# Compañia        : Yum Brands Intl
# Autor           : ARM
# Objetivo        : Applet de opciones para e-Yum
# Fecha Creacion  : 29/Enero/2004
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
# 09/Feb/2004       JPG           Integración con la plantilla de reportes y estandarización
# 16/Mar/2004       JPG           Personalización por reporte
# 24/Mar/2004       JPG           Validacion de selecciones
# 19/Abr/2004       JPG           Integración del profile de usuarios
# 12/Jul/2004       JPG           Programación y estandarización de las opciones para reportes especificos.
##########################################################################################################
*/

import javax.swing.*;
import javax.swing.tree.*;
import javax.swing.event.*;
import javax.swing.text.*;
import java.lang.String;
import java.awt.*;
import java.io.*;
import java.net.*;
import java.util.*;
import java.awt.event.*;
import java.text.*;
import netscape.javascript.*;

public class YumOptions extends javax.swing.JApplet {
    private DefaultTreeModel treeModelOrg;
    private DefaultTreeModel treeModelTime;
    private DefaultTreeModel treeModelGeneral;
    private String msCurrentPage;
    private String msPageTarget;
    private String msCurrentPageOpts;
    private String msOptionExceptions;
    
    private String msUserLevel;
    private String msUserOptions;
    private boolean mbIsIE;
    private boolean mbIsNN;
    private PopulateOrgTree moOrgTree;
    private PopulateTimeTree moTimeTree;
    private PopulateOrgTree moGeneralTree;
    private int miOrgLengthBk = -1;
    private String msMMixStruct;
    private String msInvStruct;
    
    public String msUrl;
    public AppParameters moItemChangeValue = new AppParameters();
    
    public void init() {
        initComponents();
        adjustLayout(false, 0);
        
        //Para producción
        msUrl = getCodeBase().getHost();
        if (getCodeBase().getPort()!=-1) msUrl+= ":" + getCodeBase().getPort();
        
        //Pruebas desde el IDE
        //msUrl = getCodeBase().getHost() + ":8083";    
        
        updateUserOptions(this.getParameter("psUserLevel"),this.getParameter("psUserOptions"), this.getParameter("psUserAgent"));
        //updateUserOptions("10","KFC,PH","MSIE");      //Pruebas
        
        moOrgTree = new PopulateOrgTree(msUrl,msUserLevel,msUserOptions);
        moTimeTree = new PopulateTimeTree(msUrl);
        fillMiscData();
        
        updateRptOptions("","","","");
        //updateRptOptions("23","","KFC,PH|30,20");       //Pruebas
        //this.moCmbClnitem2.enable(false) ; //Deshabilita cOmboBox
    }
    
    private void fillMiscData() {
        ServletConnection loServletConnection = new ServletConnection();
        msMMixStruct = loServletConnection.getData("MMixYum.txt",msUrl,"","");
        msInvStruct = loServletConnection.getData("InventoryYum.txt",msUrl,"","");
    }

    private void initComponents() {//GEN-BEGIN:initComponents
        moReporte = new javax.swing.JButton();
        moImprimir = new javax.swing.JButton();
        moExcel = new javax.swing.JButton();
        moChkCompany = new javax.swing.JCheckBox();
        moChkRegion = new javax.swing.JCheckBox();
        moChkZona = new javax.swing.JCheckBox();
        moChkArea = new javax.swing.JCheckBox();
        moChkStore = new javax.swing.JCheckBox();
        moOptTodos = new javax.swing.JRadioButton();
        moOptSameStore = new javax.swing.JRadioButton();
        moOptNewStore = new javax.swing.JRadioButton();
        moBtnBuscarOrg = new javax.swing.JButton();
        scrollOrg = new javax.swing.JScrollPane();
        OrgTree = new javax.swing.JTree();
        ScrollTime = new javax.swing.JScrollPane();
        TimeTree = new javax.swing.JTree();
        moBtnGoToReport = new javax.swing.JButton();
        moBtnDefaultOptsOrg = new javax.swing.JButton();
        moBtnDefaultOptsTime = new javax.swing.JButton();
        moJpnMoreOptions = new javax.swing.JPanel();
        moCmbExtraOptions1 = new javax.swing.JComboBox();
        moCmbExtraOptions2 = new javax.swing.JComboBox();
        moChkExtraOptions1 = new javax.swing.JCheckBox();
        moScrExtraOptions1 = new javax.swing.JScrollPane();
        moTreExtraOptions1 = new javax.swing.JTree();
        moBtnExtraOption1 = new javax.swing.JButton();
        moChkKeepSelectionGrl = new javax.swing.JCheckBox();
        moBtnExtraOption2 = new javax.swing.JButton();
        moChkExtraM1 = new javax.swing.JCheckBox();
        moChkExtraM2 = new javax.swing.JCheckBox();
        moChkExtraM3 = new javax.swing.JCheckBox();
        moChkExtraM4 = new javax.swing.JCheckBox();
        moChkOnlyTotals = new javax.swing.JCheckBox();

        getContentPane().setLayout(null);

        moReporte.setFont(new java.awt.Font("Arial", 1, 10));
        moReporte.setIcon(new javax.swing.ImageIcon(getImage(getDocumentBase(),"/Images/Menu/execute_button.gif")));
        moReporte.setText("Ejecutar");
        moReporte.setToolTipText("Ejecuta el reporte actual");
        moReporte.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        moReporte.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moReporteActionPerformed(evt);
            }
        });

        getContentPane().add(moReporte);
        moReporte.setBounds(0, 360, 110, 20);

        moImprimir.setFont(new java.awt.Font("Arial", 1, 10));
        moImprimir.setIcon(new javax.swing.ImageIcon(getImage(getDocumentBase(),"/Images/Menu/print_button.gif")));
        moImprimir.setText("Imprimir");
        moImprimir.setToolTipText("Imprime el reporte actual");
        moImprimir.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        moImprimir.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moImprimirActionPerformed(evt);
            }
        });

        getContentPane().add(moImprimir);
        moImprimir.setBounds(120, 360, 100, 20);

        moExcel.setFont(new java.awt.Font("Arial", 1, 10));
        moExcel.setIcon(new javax.swing.ImageIcon(getImage(getDocumentBase(),"/Images/Menu/excel_button.gif")));
        moExcel.setText("Excel");
        moExcel.setToolTipText("Exporta a excel el reporte actual");
        moExcel.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        moExcel.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moExcelActionPerformed(evt);
            }
        });

        getContentPane().add(moExcel);
        moExcel.setBounds(230, 360, 90, 20);

        moChkCompany.setFont(new java.awt.Font("Arial", 0, 9));
        moChkCompany.setText("Compa\u00f1ia");
        moChkCompany.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moChkCompanyActionPerformed(evt);
            }
        });
        moChkCompany.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                moChkCompanyItemStateChanged(evt);
            }
        });

        getContentPane().add(moChkCompany);
        moChkCompany.setBounds(170, 160, 67, 21);

        moChkRegion.setFont(new java.awt.Font("Arial", 0, 9));
        moChkRegion.setText("Region");
        moChkRegion.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moChkRegionActionPerformed(evt);
            }
        });
        moChkRegion.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                moChkRegionItemStateChanged(evt);
            }
        });

        getContentPane().add(moChkRegion);
        moChkRegion.setBounds(170, 180, 54, 21);

        moChkZona.setFont(new java.awt.Font("Arial", 0, 9));
        moChkZona.setText("Zona");
        moChkZona.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moChkZonaActionPerformed(evt);
            }
        });
        moChkZona.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                moChkZonaItemStateChanged(evt);
            }
        });

        getContentPane().add(moChkZona);
        moChkZona.setBounds(170, 200, 46, 21);

        moChkArea.setFont(new java.awt.Font("Arial", 0, 9));
        moChkArea.setText("Area");
        moChkArea.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                moChkAreaItemStateChanged(evt);
            }
        });

        getContentPane().add(moChkArea);
        moChkArea.setBounds(170, 220, 50, 21);

        moChkStore.setFont(new java.awt.Font("Arial", 0, 9));
        moChkStore.setText("Restaurante");
        moChkStore.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                moChkStoreItemStateChanged(evt);
            }
        });

        getContentPane().add(moChkStore);
        moChkStore.setBounds(170, 240, 80, 20);

        moOptTodos.setFont(new java.awt.Font("Arial", 0, 9));
        moOptTodos.setSelected(true);
        moOptTodos.setText("Todos");
        moOptTodos.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moOptTodosActionPerformed(evt);
            }
        });
        moOptTodos.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                moOptTodosItemStateChanged(evt);
            }
        });

        getContentPane().add(moOptTodos);
        moOptTodos.setBounds(240, 180, 50, 21);

        moOptSameStore.setFont(new java.awt.Font("Arial", 0, 9));
        moOptSameStore.setText("Same Store");
        moOptSameStore.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moOptSameStoreActionPerformed(evt);
            }
        });
        moOptSameStore.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                moOptSameStoreItemStateChanged(evt);
            }
        });

        getContentPane().add(moOptSameStore);
        moOptSameStore.setBounds(240, 200, 74, 20);

        moOptNewStore.setFont(new java.awt.Font("Arial", 0, 9));
        moOptNewStore.setText("New Store");
        moOptNewStore.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                moOptNewStoreItemStateChanged(evt);
            }
        });

        getContentPane().add(moOptNewStore);
        moOptNewStore.setBounds(240, 220, 68, 21);

        moBtnBuscarOrg.setFont(new java.awt.Font("Arial", 1, 10));
        moBtnBuscarOrg.setText("Buscar");
        moBtnBuscarOrg.setToolTipText("Busca elementos especificos de organizaci\u00f3n");
        moBtnBuscarOrg.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moBtnBuscarOrgActionPerformed(evt);
            }
        });
        moBtnBuscarOrg.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                moBtnBuscarOrgMouseClicked(evt);
            }
        });

        getContentPane().add(moBtnBuscarOrg);
        moBtnBuscarOrg.setBounds(0, 130, 90, 20);

        scrollOrg.setPreferredSize(new java.awt.Dimension(72, 363));
        OrgTree.setFont(new java.awt.Font("Arial", 0, 9));
        OrgTree.addTreeSelectionListener(new javax.swing.event.TreeSelectionListener() {
            public void valueChanged(javax.swing.event.TreeSelectionEvent evt) {
                OrgTreeValueChanged(evt);
            }
        });

        scrollOrg.setViewportView(OrgTree);

        getContentPane().add(scrollOrg);
        scrollOrg.setBounds(0, 0, 320, 130);

        TimeTree.setFont(new java.awt.Font("Arial", 0, 9));
        TimeTree.addTreeSelectionListener(new javax.swing.event.TreeSelectionListener() {
            public void valueChanged(javax.swing.event.TreeSelectionEvent evt) {
                TimeTreeValueChanged(evt);
            }
        });

        ScrollTime.setViewportView(TimeTree);

        getContentPane().add(ScrollTime);
        ScrollTime.setBounds(0, 150, 170, 120);

        moBtnGoToReport.setFont(new java.awt.Font("Arial", 1, 10));
        moBtnGoToReport.setIcon(new javax.swing.ImageIcon(getImage(getDocumentBase(),"/Images/Menu/search_rpt_button.gif")));
        moBtnGoToReport.setText("Ir a reporte");
        moBtnGoToReport.setToolTipText("Va al reporte especificado");
        moBtnGoToReport.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moBtnGoToReportActionPerformed(evt);
            }
        });

        getContentPane().add(moBtnGoToReport);
        moBtnGoToReport.setBounds(100, 130, 120, 20);

        moBtnDefaultOptsOrg.setFont(new java.awt.Font("Arial", 1, 10));
        moBtnDefaultOptsOrg.setText("Restaurar");
        moBtnDefaultOptsOrg.setToolTipText("Selecciona las opciones de organizaci\u00f3n predeterminadas para el reporte actual");
        moBtnDefaultOptsOrg.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moBtnDefaultOptsOrgActionPerformed(evt);
            }
        });

        getContentPane().add(moBtnDefaultOptsOrg);
        moBtnDefaultOptsOrg.setBounds(230, 130, 90, 20);

        moBtnDefaultOptsTime.setFont(new java.awt.Font("Arial", 1, 10));
        moBtnDefaultOptsTime.setText("Restaurar");
        moBtnDefaultOptsTime.setToolTipText("Selecciona las opciones de tiempo predeterminadas para el reporte actual");
        moBtnDefaultOptsTime.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moBtnDefaultOptsTimeActionPerformed(evt);
            }
        });

        getContentPane().add(moBtnDefaultOptsTime);
        moBtnDefaultOptsTime.setBounds(0, 270, 90, 20);

        moJpnMoreOptions.setLayout(null);

        moJpnMoreOptions.setBorder(new javax.swing.border.TitledBorder(null, "M\u00e1s opciones", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Arial", 0, 9)));
        moCmbExtraOptions1.setFont(new java.awt.Font("Arial", 0, 9));
        moCmbExtraOptions1.setToolTipText("Destino Champs");
        moCmbExtraOptions1.setName("moChmDestiny");
        moCmbExtraOptions1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moCmbExtraOptions1ActionPerformed(evt);
            }
        });

        moJpnMoreOptions.add(moCmbExtraOptions1);
        moCmbExtraOptions1.setBounds(20, 20, 130, 20);

        moCmbExtraOptions2.setFont(new java.awt.Font("Arial", 0, 9));
        moCmbExtraOptions2.setToolTipText("Destino Champs");
        moCmbExtraOptions2.setName("moChmDestiny");
        moJpnMoreOptions.add(moCmbExtraOptions2);
        moCmbExtraOptions2.setBounds(160, 20, 130, 20);

        moChkExtraOptions1.setFont(new java.awt.Font("Arial", 0, 9));
        moChkExtraOptions1.setText("Ver Encuestas Semanales");
        moChkExtraOptions1.setToolTipText("Ver Encuestas");
        moChkExtraOptions1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moChkExtraOptions1ActionPerformed(evt);
            }
        });
        moChkExtraOptions1.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                moChkExtraOptions1StateChanged(evt);
            }
        });
        moChkExtraOptions1.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                moChkExtraOptions1ItemStateChanged(evt);
            }
        });

        moJpnMoreOptions.add(moChkExtraOptions1);
        moChkExtraOptions1.setBounds(160, 20, 130, 21);

        moTreExtraOptions1.setFont(new java.awt.Font("Arial", 0, 9));
        moScrExtraOptions1.setViewportView(moTreExtraOptions1);

        moJpnMoreOptions.add(moScrExtraOptions1);
        moScrExtraOptions1.setBounds(10, 20, 300, 100);

        moBtnExtraOption1.setFont(new java.awt.Font("Arial", 0, 9));
        moBtnExtraOption1.setText("Buscar");
        moBtnExtraOption1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moBtnExtraOption1ActionPerformed(evt);
            }
        });

        moJpnMoreOptions.add(moBtnExtraOption1);
        moBtnExtraOption1.setBounds(10, 130, 80, 20);

        moChkKeepSelectionGrl.setFont(new java.awt.Font("Arial", 0, 9));
        moChkKeepSelectionGrl.setText("Mantener selecci\u00f3n");
        moChkKeepSelectionGrl.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moChkKeepSelectionGrlActionPerformed(evt);
            }
        });

        moJpnMoreOptions.add(moChkKeepSelectionGrl);
        moChkKeepSelectionGrl.setBounds(190, 130, 120, 21);

        moBtnExtraOption2.setFont(new java.awt.Font("Arial", 0, 9));
        moBtnExtraOption2.setText("Restaurar");
        moBtnExtraOption2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moBtnExtraOption2ActionPerformed(evt);
            }
        });

        moJpnMoreOptions.add(moBtnExtraOption2);
        moBtnExtraOption2.setBounds(100, 130, 80, 20);

        moChkExtraM1.setFont(new java.awt.Font("Arial", 0, 9));
        moChkExtraM1.setText("Clase");
        moChkExtraM1.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                moChkExtraM1StateChanged(evt);
            }
        });
        moChkExtraM1.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                moChkExtraM1ItemStateChanged(evt);
            }
        });

        moJpnMoreOptions.add(moChkExtraM1);
        moChkExtraM1.setBounds(230, 20, 80, 21);

        moChkExtraM2.setFont(new java.awt.Font("Arial", 0, 9));
        moChkExtraM2.setText("Subclase");
        moChkExtraM2.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                moChkExtraM2ItemStateChanged(evt);
            }
        });

        moJpnMoreOptions.add(moChkExtraM2);
        moChkExtraM2.setBounds(230, 40, 80, 21);

        moChkExtraM3.setFont(new java.awt.Font("Arial", 0, 9));
        moChkExtraM3.setText("Microclase");
        moChkExtraM3.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                moChkExtraM3ItemStateChanged(evt);
            }
        });

        moJpnMoreOptions.add(moChkExtraM3);
        moChkExtraM3.setBounds(230, 60, 80, 21);

        moChkExtraM4.setFont(new java.awt.Font("Arial", 0, 9));
        moChkExtraM4.setText("Item");
        moChkExtraM4.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                moChkExtraM4ItemStateChanged(evt);
            }
        });

        moJpnMoreOptions.add(moChkExtraM4);
        moChkExtraM4.setBounds(230, 80, 80, 21);

        getContentPane().add(moJpnMoreOptions);
        moJpnMoreOptions.setBounds(0, 300, 320, 50);

        moChkOnlyTotals.setFont(new java.awt.Font("Arial", 0, 9));
        moChkOnlyTotals.setText("Solo totales");
        moChkOnlyTotals.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                moChkOnlyTotalsActionPerformed(evt);
            }
        });
        moChkOnlyTotals.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                moChkOnlyTotalsItemStateChanged(evt);
            }
        });

        getContentPane().add(moChkOnlyTotals);
        moChkOnlyTotals.setBounds(90, 270, 80, 20);

    }//GEN-END:initComponents

    private void moChkOnlyTotalsItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_moChkOnlyTotalsItemStateChanged
        switch (evt.getStateChange()) {
            case ItemEvent.SELECTED:   moItemChangeValue.msOnlyTotals="1"; break;
            case ItemEvent.DESELECTED: moItemChangeValue.msOnlyTotals="0"; break;
        }
    }//GEN-LAST:event_moChkOnlyTotalsItemStateChanged

    private void moChkOnlyTotalsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moChkOnlyTotalsActionPerformed
    }//GEN-LAST:event_moChkOnlyTotalsActionPerformed

    private void moChkExtraM4ItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_moChkExtraM4ItemStateChanged
        switch (evt.getStateChange()) {
            case ItemEvent.SELECTED:   moItemChangeValue.msExtraOpt6="1"; break;
            case ItemEvent.DESELECTED: moItemChangeValue.msExtraOpt6="0"; break;
        }
    }//GEN-LAST:event_moChkExtraM4ItemStateChanged

    private void moChkExtraM3ItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_moChkExtraM3ItemStateChanged
        switch (evt.getStateChange()) {
            case ItemEvent.SELECTED:   moItemChangeValue.msExtraOpt5="1"; break;
            case ItemEvent.DESELECTED: moItemChangeValue.msExtraOpt5="0"; break;
        }
    }//GEN-LAST:event_moChkExtraM3ItemStateChanged

    private void moChkExtraM2ItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_moChkExtraM2ItemStateChanged
        switch (evt.getStateChange()) {
            case ItemEvent.SELECTED:   moItemChangeValue.msExtraOpt4="1"; break;
            case ItemEvent.DESELECTED: moItemChangeValue.msExtraOpt4="0"; break;
        }
    }//GEN-LAST:event_moChkExtraM2ItemStateChanged

    private void moChkExtraM1ItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_moChkExtraM1ItemStateChanged
        switch (evt.getStateChange()) {
            case ItemEvent.SELECTED:   moItemChangeValue.msExtraOpt3="1"; break;
            case ItemEvent.DESELECTED: moItemChangeValue.msExtraOpt3="0"; break;
        }
        
    }//GEN-LAST:event_moChkExtraM1ItemStateChanged

    private void moChkExtraM1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_moChkExtraM1StateChanged
        
    }//GEN-LAST:event_moChkExtraM1StateChanged

    private void moChkRegionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moChkRegionActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_moChkRegionActionPerformed

    private void moChkKeepSelectionGrlActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moChkKeepSelectionGrlActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_moChkKeepSelectionGrlActionPerformed

    private void moBtnExtraOption2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moBtnExtraOption2ActionPerformed
        Enumeration moPaths; 
        moTreExtraOptions1.clearSelection();
        moTreExtraOptions1.setSelectionRow(0);
        moTreExtraOptions1.scrollRowToVisible(0);
        
        moPaths = moTreExtraOptions1.getExpandedDescendants(moTreExtraOptions1.getPathForRow(0));
        if (moPaths==null) return;
        while(moPaths.hasMoreElements())
            moTreExtraOptions1.collapsePath((TreePath)moPaths.nextElement());

        moTreExtraOptions1.expandRow(0);
    }//GEN-LAST:event_moBtnExtraOption2ActionPerformed

    private void moBtnExtraOption1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moBtnExtraOption1ActionPerformed
        String lsUsrInput = JOptionPane.showInputDialog("Ingresa la busqueda");
        if (lsUsrInput==null) return;
        if (lsUsrInput.trim().equals("")) return;
        
        findNodesByDesc(moTreExtraOptions1,lsUsrInput,moChkKeepSelectionGrl.isSelected());
    }//GEN-LAST:event_moBtnExtraOption1ActionPerformed

    private void adjustLayout(boolean pbStatus, int piRpt) {
        int liYPos;
        Rectangle moBorders = moJpnMoreOptions.getBounds();
        
        if(piRpt==0)
            moJpnMoreOptions.setVisible(false);
        else
            moJpnMoreOptions.setVisible(pbStatus);
        
        liYPos = (moJpnMoreOptions.isVisible())?moBorders.y + moBorders.height + 10:moBorders.y;
            
        moReporte.setLocation(moReporte.getLocation().x,liYPos);
        moImprimir.setLocation(moImprimir.getLocation().x,liYPos);
        moExcel.setLocation(moExcel.getLocation().x,liYPos);
    }
    
    public void hideResetControls() {
        moJpnMoreOptions.setSize(320,50);
        moCmbExtraOptions1.setVisible(false);
        moCmbExtraOptions1.setBounds(10,20,130,20);
        moCmbExtraOptions2.setVisible(false);
        moChkExtraOptions1.setVisible(false);
        moScrExtraOptions1.setVisible(false);
        moChkArea.setVisible(true);
        moChkStore.setVisible(true);
        moChkRegion.setText("Region");
        moChkZona.setText("Zona");
        
        moChkExtraM1.setVisible(false);
        moChkExtraM2.setVisible(false);
        moChkExtraM3.setVisible(false);
        moChkExtraM4.setVisible(false);
        
        moScrExtraOptions1.setSize(300, 110);
    }
  
    private void moChkExtraOptions1ItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_moChkExtraOptions1ItemStateChanged
        switch ( evt.getStateChange()) {
            case ItemEvent.SELECTED: moItemChangeValue.msExtraOpt2 ="1" ; break;
            case ItemEvent.DESELECTED: moItemChangeValue.msExtraOpt2 ="0" ; break;
          }   
    }//GEN-LAST:event_moChkExtraOptions1ItemStateChanged

    private void moChkExtraOptions1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_moChkExtraOptions1StateChanged
        
    }//GEN-LAST:event_moChkExtraOptions1StateChanged

    private void moChkExtraOptions1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moChkExtraOptions1ActionPerformed
        // Add your handling code here:
    }//GEN-LAST:event_moChkExtraOptions1ActionPerformed

    private void moCmbExtraOptions1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moCmbExtraOptions1ActionPerformed
    }//GEN-LAST:event_moCmbExtraOptions1ActionPerformed

    private void moBtnDefaultOptsTimeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moBtnDefaultOptsTimeActionPerformed
        if (msCurrentPageOpts.equals("")) { showJSAlert("No existen opciones preestablecidas para este contexto"); return; }
        fillDefaultTimeOpts();
    }//GEN-LAST:event_moBtnDefaultOptsTimeActionPerformed
    
    private void fillExtraOptions(){
        String laDestinyItems[] = new String[]{"80|Todos","20|Para llevar","30|Auto Express","50|Entrega","90|No Entrega","60|Serv Completo - Mesa","70|Serv Completo - Mostrador"};
        String laPeopleStatus[] = new String[]{"10|Activos actuales","20|Altas","30|Bajas"};
        String laAccounts[] = new String[]{"10|Cuentas de mayor","20|subcuentas"};
        String laSphdDestiny[] = new String[]{"0|Todos", "10|Comedor", "20|Llevar","50|Entrega","30|Ventana"};
        String laSphdHour[] = new String[]{"0|Horarios de comidas", "1|Todas las horas"};
        
        
        int liReportKey = 0;
        
        if (msCurrentPage.equals("")) return;
        liReportKey = Integer.parseInt(msCurrentPage);
        
        hideResetControls();
        
        switch (liReportKey) {
            case 11:    fillClientsOptions();
                        adjustLayout(true, liReportKey);
                        break;
            
            case 15:    moCmbExtraOptions1.setVisible(true);
                        moChkExtraOptions1.setVisible(true);
                        fillComboBox(moCmbExtraOptions1,laDestinyItems);
                        adjustLayout(true, liReportKey);
                        break;
                        
            case 24:    moCmbExtraOptions1.setVisible(true);
                        moCmbExtraOptions2.setVisible(true);
                        fillComboBox(moCmbExtraOptions1,laSphdDestiny);
                        fillComboBox(moCmbExtraOptions2,laSphdHour);
                        adjustLayout(true, liReportKey); 
                        break;       
                        
            case 83:    moCmbExtraOptions1.setVisible(true);
                        fillComboBox(moCmbExtraOptions1,laPeopleStatus);
                        adjustLayout(true, liReportKey); 
                        break;            
                        
            case 84:    moCmbExtraOptions1.setVisible(true);
                        fillComboBox(moCmbExtraOptions1,laPeopleStatus);
                        adjustLayout(true, liReportKey); 
                        break;                             
                        
            case 126:   moCmbExtraOptions1.setVisible(true);
                        moChkArea.setVisible(false);
                        moChkStore.setVisible(false);
                        moChkRegion.setText("Deptos.");
                        moChkZona.setText("CC");
                        fillComboBox(moCmbExtraOptions1,laAccounts);
                        adjustLayout(true, liReportKey); 
                        break;
            
            case 137:   fillClientsOptions();
                        adjustLayout(true, liReportKey);
                        break;
                        
            case 145:   fillMenuMixOptions();
                        adjustLayout(true, liReportKey); 
                        break;
                              
            case 154:   fillInventoryOptions();
                        adjustLayout(true, liReportKey); 
                        break;
                        
            default:    adjustLayout(false, liReportKey);
        }
    }
    
    public void fillMenuMixTree() {
        TreeNode loRootNode;
        moGeneralTree = new PopulateOrgTree(msUrl);
        
        loRootNode = moGeneralTree.createGenericNodesFromStr(msMMixStruct,"Todos los items","[menu_item].[todos los items]");
        treeModelGeneral = new DefaultTreeModel(loRootNode);
        moTreExtraOptions1.setModel(treeModelGeneral);
    }
    
    public void fillClientsOptions() {
        fillMenuMixTree();
        
        moJpnMoreOptions.setSize(320,160);
        moScrExtraOptions1.setVisible(true);
        moTreExtraOptions1.setSelectionRow(0);
    }
    
    
    public void fillMenuMixOptions() {
        fillMenuMixTree();

        moChkExtraM1.setVisible(true);
        moChkExtraM2.setVisible(true);
        moChkExtraM3.setVisible(true);
        moChkExtraM4.setVisible(true);

        moChkExtraM1.setSelected(true);
        moChkExtraM2.setSelected(false);
        moChkExtraM3.setSelected(false);
        moChkExtraM4.setSelected(false);
       
        moJpnMoreOptions.setSize(320,160);
        moScrExtraOptions1.setSize(210, 110);
        
        moScrExtraOptions1.setVisible(true);
        moTreExtraOptions1.setSelectionRow(0);
        moTreExtraOptions1.setVisible(true);
    }
    
    public void fillInventoryOptions() {
        TreeNode loRootNode;
        moGeneralTree = new PopulateOrgTree(msUrl);
        
        loRootNode = moGeneralTree.createGenericNodesFromStr(msInvStruct,"Todos los productos","[inventory].[Todos los productos]");
        treeModelGeneral = new DefaultTreeModel(loRootNode);
        moTreExtraOptions1.setModel(treeModelGeneral);
        
        moJpnMoreOptions.setSize(320,160);
        moScrExtraOptions1.setVisible(true);
        moTreExtraOptions1.setSelectionRow(0);
    }
    
    private void checkExtraOptions() {
        NodeItem loNodeItem;
        StringForSelection loStringSelection = new StringForSelection();
        if (msCurrentPage.equals("")) return;
        
        switch (Integer.parseInt(msCurrentPage)) {
            case 11:    loNodeItem = loStringSelection.findSelectedNodes(moTreExtraOptions1);
                        moItemChangeValue.msExtraOpt1 = loNodeItem.getCode();
                        break;
                        
            case 15:    if (moCmbExtraOptions1.getSelectedItem()!=null)
                            moItemChangeValue.msExtraOpt1 = ((NodeItem)moCmbExtraOptions1.getSelectedItem()).getCode();
                        break;
                        
            case 24:    if (moCmbExtraOptions1.getSelectedItem()!=null) moItemChangeValue.msExtraOpt1 = ((NodeItem)moCmbExtraOptions1.getSelectedItem()).getCode();
                        if (moCmbExtraOptions2.getSelectedItem()!=null) moItemChangeValue.msExtraOpt2 = ((NodeItem)moCmbExtraOptions2.getSelectedItem()).getCode();
                        break;
                        
            case 83:    if (moCmbExtraOptions1.getSelectedItem()!=null)
                            moItemChangeValue.msExtraOpt1 = ((NodeItem)moCmbExtraOptions1.getSelectedItem()).getCode();
                        break;
                        
            case 84:    if (moCmbExtraOptions1.getSelectedItem()!=null)
                            moItemChangeValue.msExtraOpt1 = ((NodeItem)moCmbExtraOptions1.getSelectedItem()).getCode();
                        break;
            
            case 126:   if (moCmbExtraOptions1.getSelectedItem()!=null) 
                            moItemChangeValue.msExtraOpt1 = ((NodeItem)moCmbExtraOptions1.getSelectedItem()).getCode();
                        break;
                        
            case 137:   loNodeItem = loStringSelection.findSelectedNodes(moTreExtraOptions1);
                        moItemChangeValue.msExtraOpt1 = loNodeItem.getCode();
                        break;
            
            case 145:   loNodeItem = loStringSelection.findSelectedNodes(moTreExtraOptions1);
                        moItemChangeValue.msExtraOpt1 = loNodeItem.getCode();
                        moItemChangeValue.msExtraOpt2 = "";
                        moItemChangeValue.msExtraOpt2 = moItemChangeValue.msExtraOpt3 + "," + moItemChangeValue.msExtraOpt4 + "," + moItemChangeValue.msExtraOpt5 + "," + moItemChangeValue.msExtraOpt6;
                        break;
                        
            case 154:   loNodeItem = loStringSelection.findSelectedNodes(moTreExtraOptions1);
                        moItemChangeValue.msExtraOpt1 = loNodeItem.getCode();
                        break;
        }
    }
     
    private void checkChkChmDetailOpts(java.awt.event.ItemEvent evt) {
        switch (evt.getStateChange()) {
            case ItemEvent.SELECTED: moItemChangeValue.msStore ="1" ; break;
            case ItemEvent.DESELECTED: moItemChangeValue.msStore ="0" ; break;
        }      
    }
        
    private void fillDefaultTimeOpts() {
        StringUtils loStringUtils = new StringUtils();
        String lsTimeOpts = "";
        int liTimeLevel = 10;
        int liSelectedRow = 0;
        
        if (loStringUtils.splitString(msCurrentPageOpts,"\\|").length>0) {
            lsTimeOpts = loStringUtils.splitString(msCurrentPageOpts,"\\|")[1];
            liTimeLevel = Integer.parseInt(loStringUtils.splitString(lsTimeOpts,",")[0]);
        }
        
        fillTimeTree(lsTimeOpts);
        if (liTimeLevel>=50) {
            Calendar loCalendar = Calendar.getInstance();
            loCalendar.roll(loCalendar.DATE,false);
            DateFormat moDateFormat = new SimpleDateFormat("dd/MM/yyyy");
            String msCurrentDate = moDateFormat.format(loCalendar.getTime());
            findNodesByDesc(TimeTree,msCurrentDate.trim(),false);
        } else {
            DefaultMutableTreeNode loRoot = (DefaultMutableTreeNode)TimeTree.getModel().getRoot();
            DefaultMutableTreeNode loLastChild = (DefaultMutableTreeNode)loRoot.getLastLeaf();
            TreePath loLastPath = new TreePath(((DefaultMutableTreeNode)loLastChild).getPath());
            TimeTree.makeVisible(loLastPath);
            TimeTree.scrollPathToVisible(loLastPath);
            TimeTree.setSelectionPath(loLastPath);
        }
    }
    
    private void moBtnDefaultOptsOrgActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moBtnDefaultOptsOrgActionPerformed
        if (msCurrentPageOpts.equals("")) { showJSAlert("No existen opciones preestablecidas para este contexto"); return;}
        
        StringUtils loStringUtils = new StringUtils();
        String lsOrgOpts = "";
        
        if (loStringUtils.splitString(msCurrentPageOpts,"\\|").length>0) {
            lsOrgOpts = loStringUtils.splitString(msCurrentPageOpts,"\\|")[0];
        }
        
        fillOrgTree(lsOrgOpts);
        for (int li = 1; li < OrgTree.getRowCount(); li++) OrgTree.addSelectionRow(li);
    }//GEN-LAST:event_moBtnDefaultOptsOrgActionPerformed

    private void moChkCompanyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moChkCompanyActionPerformed
        // Add your handling code here:
    }//GEN-LAST:event_moChkCompanyActionPerformed

    private void moOptTodosActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moOptTodosActionPerformed
        // Add your handling code here:
    }//GEN-LAST:event_moOptTodosActionPerformed

    private void moBtnGoToReportActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moBtnGoToReportActionPerformed
        searchReport();
    }//GEN-LAST:event_moBtnGoToReportActionPerformed

    public void  searchReport() {
        String lsUsrInput = JOptionPane.showInputDialog("Clave del reporte");
        if (lsUsrInput==null) return;
        try {
            JSObject loWin = (JSObject)JSObject.getWindow(this);
            loWin.eval("javascript:shootPage('F" + lsUsrInput + "'); ");
        } catch(Exception poException) {
            System.out.println("Error moBtnGoToReportActionPerformed: " + poException.getMessage());
        }
    }
    
    private void moOptSameStoreActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moOptSameStoreActionPerformed
        // Add your handling code here:
    }//GEN-LAST:event_moOptSameStoreActionPerformed

    private void moChkZonaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moChkZonaActionPerformed
        // Add your handling code here:
    }//GEN-LAST:event_moChkZonaActionPerformed

    private void moImprimirActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moImprimirActionPerformed
        executePage("PRINTER");
    }//GEN-LAST:event_moImprimirActionPerformed

    private void moExcelActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moExcelActionPerformed
        executePage("EXCEL");
    }//GEN-LAST:event_moExcelActionPerformed

    private void TimeTreeValueChanged(javax.swing.event.TreeSelectionEvent evt) {//GEN-FIRST:event_TimeTreeValueChanged
    }//GEN-LAST:event_TimeTreeValueChanged

    private void OrgTreeValueChanged(javax.swing.event.TreeSelectionEvent evt) {//GEN-FIRST:event_OrgTreeValueChanged
        int liSubsDetail=1;
        StringUtils moStringUtils = new StringUtils();
        TreePath[] laPath = evt.getPaths();
        TreePath loPath = (TreePath)evt.getPath();
        DefaultMutableTreeNode loNode;
        Object loNodeInfoOrg;
        NodeItem loNodeItem;        
        TreePath loActualPathSend;
        int liLevelCount=laPath[0].getPathCount();
        
        switch(liLevelCount){
            case 1: loActualPathSend = (TreePath)laPath[0];
                    break;
            case 2:loActualPathSend = (TreePath)laPath[0].getParentPath();
                    break;
            case 3:loActualPathSend = (TreePath)laPath[0].getParentPath().getParentPath();
                    break;
            case 4:loActualPathSend = (TreePath)laPath[0].getParentPath().getParentPath().getParentPath();
                    break;
            case 5:loActualPathSend = (TreePath)laPath[0].getParentPath().getParentPath().getParentPath().getParentPath();
                    break;
            default:loActualPathSend = (TreePath)laPath[0];
                    break;
        }  
        
        loNode = (DefaultMutableTreeNode)loActualPathSend.getLastPathComponent();
        loNodeInfoOrg = loNode.getUserObject();
        loNodeItem  = (NodeItem)loNodeInfoOrg;       
        
        int liUserLevelAux = (Integer.parseInt(msUserLevel)/10)-1;
        int liOrgLength=0;
        
        if (!loNodeItem.getCode().equals("")){
            liSubsDetail=0;
        }
        
        liOrgLength = (loPath.getPathCount()-liSubsDetail)+liUserLevelAux;
        
        if (miOrgLengthBk==liOrgLength) return;
        miOrgLengthBk = liOrgLength;
        
        initDetailLevel();
        
        if (liOrgLength>=1) this.moChkCompany.setSelected(true);
        if (liOrgLength>=2) this.moChkRegion.setSelected(true);
        if (liOrgLength>=3) this.moChkZona.setSelected(true);
        if (liOrgLength>=4) this.moChkArea.setSelected(true);
        if (liOrgLength>=5) this.moChkStore.setSelected(true);
    }//GEN-LAST:event_OrgTreeValueChanged

    private void moReporteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moReporteActionPerformed
        executePage("VIEWPORT");
    }//GEN-LAST:event_moReporteActionPerformed

    private void moOptNewStoreItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_moOptNewStoreItemStateChanged
        switch ( evt.getStateChange() ) {
            case ItemEvent.SELECTED:    moItemChangeValue.msStatusStore =".[New]"; 
                                        this.moOptTodos.setSelected(false);
                                        this.moOptSameStore.setSelected(false);
                                        break;
        }
    }//GEN-LAST:event_moOptNewStoreItemStateChanged

    private void moOptSameStoreItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_moOptSameStoreItemStateChanged
        switch ( evt.getStateChange()) {
            case ItemEvent.SELECTED:    moItemChangeValue.msStatusStore =".[Same]"; 
                                        this.moOptNewStore.setSelected(false);
                                        this.moOptTodos.setSelected(false);
                                        break;
        }
    }//GEN-LAST:event_moOptSameStoreItemStateChanged

    private void moOptTodosItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_moOptTodosItemStateChanged
        switch ( evt.getStateChange() ) {
            case ItemEvent.SELECTED:    moItemChangeValue.msStatusStore =""; 
                                        this.moOptNewStore.setSelected(false);
                                        this.moOptSameStore.setSelected(false);   
                                        break;
         }
    }//GEN-LAST:event_moOptTodosItemStateChanged

    private void moChkStoreItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_moChkStoreItemStateChanged
        switch (evt.getStateChange()) {
            case ItemEvent.SELECTED: moItemChangeValue.msStore ="1" ; break;
            case ItemEvent.DESELECTED: moItemChangeValue.msStore ="0" ; break;
        }
    }//GEN-LAST:event_moChkStoreItemStateChanged

    private void moChkAreaItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_moChkAreaItemStateChanged
        switch (evt.getStateChange()) {
            case ItemEvent.SELECTED: moItemChangeValue.msArea ="1" ; break;
            case ItemEvent.DESELECTED: moItemChangeValue.msArea ="0" ; break;
        }
    }//GEN-LAST:event_moChkAreaItemStateChanged

    private void moChkZonaItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_moChkZonaItemStateChanged
        switch (evt.getStateChange()) {
            case ItemEvent.SELECTED: moItemChangeValue.msZone ="1" ; break;
            case ItemEvent.DESELECTED: moItemChangeValue.msZone ="0" ; break;
        }
    }//GEN-LAST:event_moChkZonaItemStateChanged

    private void moChkRegionItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_moChkRegionItemStateChanged
        switch (evt.getStateChange()) {
            case ItemEvent.SELECTED: moItemChangeValue.msRegion ="1" ; break;
            case ItemEvent.DESELECTED: moItemChangeValue.msRegion ="0" ; break;
        }
    }//GEN-LAST:event_moChkRegionItemStateChanged

    private void moChkCompanyItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_moChkCompanyItemStateChanged
        switch (evt.getStateChange()) {
            case ItemEvent.SELECTED: moItemChangeValue.msCompany="1" ; break;
            case ItemEvent.DESELECTED: moItemChangeValue.msCompany="0" ; break;
        }
    }//GEN-LAST:event_moChkCompanyItemStateChanged
    
    private void moBtnBuscarOrgMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_moBtnBuscarOrgMouseClicked
        // Add your handling code here:
    }//GEN-LAST:event_moBtnBuscarOrgMouseClicked

    private void fillComboBox(javax.swing.JComboBox poComboBox, String psQuery) {
        
    }
    
    private void fillComboBox(javax.swing.JComboBox poComboBox, String paVector[]) {
        StringUtils moStringUtils = new StringUtils();
        String laItemData[];
        poComboBox.removeAllItems();
        
        for (int li = 0; li < paVector.length; li++) {
            laItemData = moStringUtils.splitString(paVector[li],"\\|");
            poComboBox.addItem(new NodeItem(laItemData[1],laItemData[0]));
        }
    }
    
    private void fillComboBox(javax.swing.JComboBox poComboBox, String paMatrix[][]) {
        poComboBox.removeAllItems();
        for (int li = 0; li < paMatrix.length; li++) 
            poComboBox.addItem(new NodeItem(paMatrix[li][1],paMatrix[li][0]));
    }
    
    public void executePage(String psPresentation) {
        StringForSelection loStringSelection = new StringForSelection();
        NodeItem loNodeItem;
        String lsRptTarget = (!psPresentation.equals("PRINTER"))?msPageTarget:"_blank";
        
        //JOptionPane.showMessageDialog(this,"","Advertencia",2);  
        
        loNodeItem = loStringSelection.findSelectedNodes(OrgTree);
        moItemChangeValue.setOrgParameters("","");
        if (validOrganization()) {
            if (loNodeItem==null) {
                showJSAlert("No se han seleccionado opciones de organización");
                return;
            } 
            moItemChangeValue.setOrgParameters(loNodeItem.getText(),loNodeItem.getCode());
        }
        
        loNodeItem = loStringSelection.findSelectedNodes(TimeTree);
        moItemChangeValue.setTimeParameters("","");
        if (validTime()) {
            if (loNodeItem==null) {
                showJSAlert("No se han seleccionado opciones de tiempo");
                return;
            }
            moItemChangeValue.setTimeParameters(loNodeItem.getCode(),loNodeItem.getCode());
        }
        
        checkExtraOptions();
        
        if (!validateOrgTimeLevels()) return;
        
        AppParameters loAppParameters = new AppParameters();
        moItemChangeValue.msPresentation = psPresentation;
        ServletConnection moServletConnection = new ServletConnection("/servlet/generals.servlets.DialogOptions");
        moServletConnection.sendPost(msUrl,msCurrentPage);
        
        try{
            JSObject loWin = (JSObject)JSObject.getWindow(this);
            loWin.eval("javascript:executeReport('" + lsRptTarget + "','" + psPresentation + "'); ");
        }catch (Exception poException) {
            System.out.println("Error: executePage" + poException.getMessage());
        }
    }
    
    private void showJSAlert(String psMessage) {
        try {
            JSObject loWin = (JSObject)JSObject.getWindow(this);
            loWin.eval("javascript:alert('" + psMessage + "'); ");
        } catch(Exception poException) {
            System.out.println("Error: showJSAlert" + poException.getMessage());
        }
    }
    
    private void executeJSCommand(String psCommand) {
        try {
            JSObject loWin = (JSObject)JSObject.getWindow(this);
            loWin.eval(psCommand);
        } catch(Exception poException) {
            System.out.println("Error: executeJSCommand" + poException.getMessage());
        }
    }
    
    private boolean validateOrgTimeLevels() {
        StringUtils moStringUtils = new StringUtils();
        String laOrgMembers[] = moStringUtils.splitString(moItemChangeValue.msOrgMembers,",");
        String laTimeMembers[] = moStringUtils.splitString(moItemChangeValue.msTimeMembers,",");
        int liOrgLength = (!moItemChangeValue.msOrgMembers.equals(""))?moStringUtils.splitString(laOrgMembers[0],".").length:0;
        int liTimeLength = (!moItemChangeValue.msTimeMembers.equals(""))?moStringUtils.splitString(laTimeMembers[0],".").length:0;
        
        for (int li = 0; li<laOrgMembers.length; li++) {
            if (moStringUtils.splitString(laOrgMembers[li],".").length != liOrgLength) {
                showJSAlert("No se permite seleccionar distintos niveles de organización");
                return(false);
            }
        }
        
        for (int li = 0; li<laTimeMembers.length; li++) {
            if (moStringUtils.splitString(laTimeMembers[li],".").length != liTimeLength) {
                showJSAlert("No se permite seleccionar distintos niveles de tiempo");
                return(false);
            }
        }
        
        if (laTimeMembers.length <= 1) moChkOnlyTotals.setSelected(false);
        
        return(true);
    }
    
    public void initDetailLevel() {
        this.moChkCompany.setSelected(false);
        this.moChkRegion.setSelected(false);
        this.moChkZona.setSelected(false);
        this.moChkArea.setSelected(false);
        this.moChkStore.setSelected(false);
    }
    
    public void setUserLevel(String psUserLevel) {
        msUserLevel = psUserLevel;
    } 
    
    public void setUserOptions(String psUserOptions) {
        msUserOptions = psUserOptions;
    }
    
    private void setNavigatorType(String psUserAgent) {
        mbIsIE = (psUserAgent.indexOf("MSIE") != -1)?true:false;
        mbIsNN = !mbIsIE;
    }
    
    public void setCurrentPage(String psCurrentPage) {
        msCurrentPage = psCurrentPage;
    }
    
    public void setPageTarget(String psPageTarget) {
        msPageTarget = psPageTarget;
    }
    
    public void setCurrentPageOpts(String psCurrentPageOpts) {
        msCurrentPageOpts = psCurrentPageOpts;
    }
    
    public void setOptionExceptions(String psOptionExceptions) {
        msOptionExceptions = psOptionExceptions;
    }
    
    public boolean validOrganization() {
        if (msOptionExceptions.equals("")) return(true);
        if (msOptionExceptions.split("\\|")[0].equals("NOT")) return(false);
        return(true);
    }
    
    public boolean validTime() {
        if (msOptionExceptions.equals("")) return(true);
        if (msOptionExceptions.split("\\|")[1].equals("NOT")) return(false);
        return(true);
    }
    
    public void updateUserOptions(String psUserLevel, String psUserOptions, String psUserAgent) {
        setUserLevel(psUserLevel);
        setUserOptions(psUserOptions);
        setNavigatorType(psUserAgent);
    }
    
    public void dummieFunction() {}
        
    public void updateRptOptions(String psCurrentPage,String psPageTarget, String psCurrentPageOpts, String psOptionExceptions) {
        StringUtils loStringUtils = new StringUtils();
        String lsOrgOpts = "";
        String lsTimeOpts = "";
        String lsProfileData = "";
        ServletConnection loServletConnection = new ServletConnection("/servlet/generals.servlets.ProfileOptions");
        
        setCurrentPage(psCurrentPage);
        setPageTarget(psPageTarget);
        setCurrentPageOpts(psCurrentPageOpts);
        setOptionExceptions(psOptionExceptions);
        
        if (loStringUtils.splitString(msCurrentPageOpts,"\\|").length>0) {
            lsOrgOpts = loStringUtils.splitString(msCurrentPageOpts,"\\|")[0];
            lsTimeOpts = loStringUtils.splitString(msCurrentPageOpts,"\\|")[1];
        }

        fillOrgTree(lsOrgOpts);
        fillTimeTree(lsTimeOpts);
        fillExtraOptions();
        
        if (psCurrentPageOpts.equals("")) return;
      
        if (mbIsIE) lsProfileData = loServletConnection.getData(msCurrentPage,msUrl,"","");
        if (lsProfileData.equals("Error")) {
            executeJSCommand("handleProxyException();");
            return;
        }
        
        //lsProfileData = "&[PH].&[P1000],&[KFC].&[K1000]|[2004].[1]|1,1,0,0,0|T";
        if (!lsProfileData.equals(""))
            fillOptionsFromProfile(lsProfileData);
        else
            fillDefaultOptions();
       
    }
    
    private void fillDefaultOptions() {
        fillDefaultTimeOpts();
        this.moOptTodos.setSelected(true);
        moItemChangeValue.msStatusStore = "";
    }
    
    public void fillOrgTree(String psOrgOpts) {
        int liReportKey=0;
        msCurrentPage = (msCurrentPage.equals(""))?"0":msCurrentPage;
        liReportKey = Integer.parseInt(msCurrentPage);
        TreeNode loRootNode;
                
        switch (liReportKey) {
            case 126:                      
                        loRootNode = moOrgTree.createGenericNodes("DepartmentsYum.txt","Todos los departamentos","&[1]");
                        treeModelOrg = new DefaultTreeModel(loRootNode);
                        OrgTree.setModel(treeModelOrg);    
                        break;
                
            default:    loRootNode = moOrgTree.createNodes(psOrgOpts);
                        treeModelOrg = new DefaultTreeModel(loRootNode);
                        OrgTree.setModel(treeModelOrg);
        }
    }
    
    public void fillTimeTree(String psTimeOpts) {

             TreeNode loRootNodeTime = moTimeTree.createNodes(psTimeOpts); 
             treeModelTime = new DefaultTreeModel(loRootNodeTime);
             TimeTree.setModel(treeModelTime);

    }    
    
    public void fillOptionsFromProfile(String psProfile) {
        try {
            StringUtils loStringUtils = new StringUtils();
            String laProfile[] = loStringUtils.splitString(psProfile,"\\|");

            //Organization
            findNodesByCode(OrgTree,loStringUtils.splitString(laProfile[0],","));

            //Time
            findNodesByCode(TimeTree,loStringUtils.splitString(laProfile[1],","));

            //Detail
            String laDetail[] = loStringUtils.splitString(laProfile[2],",");

            this.moChkCompany.setSelected(laDetail[0].equals("1")?true:false);
            this.moChkRegion.setSelected(laDetail[1].equals("1")?true:false);
            this.moChkZona.setSelected(laDetail[2].equals("1")?true:false);
            this.moChkArea.setSelected(laDetail[3].equals("1")?true:false);
            this.moChkStore.setSelected(laDetail[4].equals("1")?true:false);

            //Status
            moOptTodos.setSelected(false);
            moOptSameStore.setSelected(false);
            moOptNewStore.setSelected(false);

            switch(laProfile[3].charAt(0)) {
                case 'T': this.moOptTodos.setSelected(true); moItemChangeValue.msStatusStore = "";              break;
                case 'S': this.moOptSameStore.setSelected(true); moItemChangeValue.msStatusStore = ".[Same]";   break;
                case 'N': this.moOptNewStore.setSelected(true); moItemChangeValue.msStatusStore = ".[New]";     break;
                default:  this.moOptTodos.setSelected(true);
            }
            
        } catch(Exception poException) {
            printError(poException,"fillOptionFromProfile: ");
        }
    }
    
    public void findNodesByCode(JTree poTree,String paSearchs[]) {
        TreeNode loRoot = (TreeNode)poTree.getModel().getRoot();
        DefaultMutableTreeNode loNewNode = (DefaultMutableTreeNode)loRoot;
        Enumeration loCursor = loNewNode.postorderEnumeration();
        DefaultMutableTreeNode loCurrNode;
        NodeItem loNodeItem;
        TreePath loPath = null;
        
        try {
            while (loCursor.hasMoreElements()) {
                loCurrNode = (DefaultMutableTreeNode)loCursor.nextElement();
                loNodeItem = (NodeItem)loCurrNode.getUserObject();
                String lsSearchingCode = loNodeItem.getCode().toUpperCase().trim();

                for (int li = 0; li < paSearchs.length; li ++) {
                    String lsSearch = paSearchs[li].toUpperCase().trim();
                    if (lsSearchingCode.equals(lsSearch)) { 
                        loPath=new TreePath((( DefaultMutableTreeNode)loCurrNode ).getPath());
                        poTree.makeVisible(loPath);
                        poTree.addSelectionPath(loPath);
                    }
                }
            } 
            if (loPath != null) poTree.scrollPathToVisible(loPath);
            
         } catch(Exception poException)  {
             printError(poException,"fillOptionFromProfile: ");
         }
    }
    
    public void findNodesByMember(JTree poTree,String paSearchs[]) {
        TreeNode loRoot = (TreeNode)poTree.getModel().getRoot();
        DefaultMutableTreeNode loNewNode = (DefaultMutableTreeNode)loRoot;
        Enumeration loCursor = loNewNode.postorderEnumeration();
        DefaultMutableTreeNode loCurrNode;
        NodeItem loNodeItem;
        TreePath loPath = null;
        
        poTree.clearSelection();
        while (loCursor.hasMoreElements()) {
            loCurrNode = (DefaultMutableTreeNode)loCursor.nextElement();
            loNodeItem = (NodeItem)loCurrNode.getUserObject();
            String lsSearchingCode = loNodeItem.getCode().toUpperCase().trim();
            for (int li = 0; li < paSearchs.length; li ++) {
                String lsSearch = "[" + paSearchs[li].toUpperCase().trim() + "]";
                if (lsSearchingCode.indexOf(lsSearch)!=-1) {
                    loPath=new TreePath((( DefaultMutableTreeNode)loCurrNode ).getPath());
                    poTree.makeVisible(loPath);
                    poTree.addSelectionPath(loPath);
                }
            }
        }

        if (loPath != null) poTree.scrollPathToVisible(loPath);
    }
    
    public void findNodesByDesc(JTree poTree,String psSearch, boolean pbMultipleFlag) {
        TreeNode loRoot = (TreeNode)poTree.getModel().getRoot();
        DefaultMutableTreeNode loNewNode = (DefaultMutableTreeNode)loRoot;
        Enumeration loCursor = loNewNode.postorderEnumeration();
        DefaultMutableTreeNode loCurrNode;
        NodeItem loNodeItem;
        
        while (loCursor.hasMoreElements()) {
            loCurrNode = (DefaultMutableTreeNode)loCursor.nextElement();
            loNodeItem = (NodeItem)loCurrNode.getUserObject();
            String lsSearchingText = loNodeItem.getText().toUpperCase().trim();
            String lsSearchingCode = loNodeItem.getCode().toUpperCase().trim();
            String lsSearch = psSearch.toUpperCase().trim();
            
            if (lsSearchingText.indexOf(lsSearch) > -1 || lsSearchingCode.equals(lsSearch)) { 
                TreePath loPath=new TreePath((( DefaultMutableTreeNode)loCurrNode ).getPath());
                poTree.makeVisible(loPath);
                if (pbMultipleFlag) {
                    if (poTree.isRowSelected(poTree.getRowForPath(loPath))) continue;
                    poTree.addSelectionRow(poTree.getRowForPath(loPath));
                } else
                    poTree.setSelectionRow(poTree.getRowForPath(loPath));
                
                poTree.scrollPathToVisible(loPath) ;
                return;
            } 
        } 
    }
    
    private void printError(Exception poException, String psPostMessage) {
        poException.printStackTrace();
        System.out.println(psPostMessage + poException.getMessage());
    }
    
    private void moBtnBuscarOrgActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_moBtnBuscarOrgActionPerformed
        StringUtils loStringUtils = new StringUtils();
        String lsUsrInput = JOptionPane.showInputDialog("Ingresa la Busqueda");
        if (lsUsrInput != null) {
            if (lsUsrInput.indexOf(",")!=-1)
                findNodesByMember(OrgTree,loStringUtils.splitString(lsUsrInput,","));
            else
                findNodesByDesc(OrgTree,lsUsrInput,false); 
        }
    }//GEN-LAST:event_moBtnBuscarOrgActionPerformed
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTree OrgTree;
    private javax.swing.JScrollPane ScrollTime;
    private javax.swing.JTree TimeTree;
    private javax.swing.JButton moBtnBuscarOrg;
    private javax.swing.JButton moBtnDefaultOptsOrg;
    private javax.swing.JButton moBtnDefaultOptsTime;
    private javax.swing.JButton moBtnExtraOption1;
    private javax.swing.JButton moBtnExtraOption2;
    private javax.swing.JButton moBtnGoToReport;
    private javax.swing.JCheckBox moChkArea;
    private javax.swing.JCheckBox moChkCompany;
    private javax.swing.JCheckBox moChkExtraM1;
    private javax.swing.JCheckBox moChkExtraM2;
    private javax.swing.JCheckBox moChkExtraM3;
    private javax.swing.JCheckBox moChkExtraM4;
    private javax.swing.JCheckBox moChkExtraOptions1;
    private javax.swing.JCheckBox moChkKeepSelectionGrl;
    private javax.swing.JCheckBox moChkOnlyTotals;
    private javax.swing.JCheckBox moChkRegion;
    private javax.swing.JCheckBox moChkStore;
    private javax.swing.JCheckBox moChkZona;
    private javax.swing.JComboBox moCmbExtraOptions1;
    private javax.swing.JComboBox moCmbExtraOptions2;
    private javax.swing.JButton moExcel;
    private javax.swing.JButton moImprimir;
    private javax.swing.JPanel moJpnMoreOptions;
    private javax.swing.JRadioButton moOptNewStore;
    private javax.swing.JRadioButton moOptSameStore;
    private javax.swing.JRadioButton moOptTodos;
    private javax.swing.JButton moReporte;
    private javax.swing.JScrollPane moScrExtraOptions1;
    private javax.swing.JTree moTreExtraOptions1;
    private javax.swing.JScrollPane scrollOrg;
    // End of variables declaration//GEN-END:variables
}

class ServletConnection {
    private String msServletName;

    public ServletConnection () {
        msServletName = "/servlet/generals.servlets.YumData";
    }
    
    public ServletConnection (String psServletName) {
        msServletName = psServletName;
    }
    
    public String getData(String psServletOpts, String psUrl, String psUserLevel, String psUserOptions){
        URL moMyurl = null;
        String lsReturn = "";
        String lsQry = "" ;
        StringUtils loStringUtils = new StringUtils();
        
        lsQry  = "psServletOpts=" + URLEncoder.encode(psServletOpts);
        
        try {
            String lsUrl = "http://" + psUrl + msServletName;
            moMyurl = new URL(lsUrl);
            
            URLConnection loConexion = moMyurl.openConnection();
            loConexion.setDoOutput(true);
            loConexion.setDoInput(true);
            loConexion.setUseCaches (false);
            loConexion.setDefaultUseCaches (false);
            
            //System.out.println("before OutputStream \n" + lsQry + "\n");
            OutputStreamWriter buffersalida = new OutputStreamWriter(loConexion.getOutputStream());
            //System.out.println("after OutputStream \n");
            buffersalida.write(lsQry);
            buffersalida.flush();
            
            BufferedReader bufferentrada = new BufferedReader(new InputStreamReader(loConexion.getInputStream()));
            String lsLinea = null;
            if (psServletOpts.equals("OrganizationYum.txt")) {
                int piUsrLevel = Integer.parseInt(psUserLevel);
                String laUserOptions[] = loStringUtils.splitString(psUserOptions,",");
                
                while ((lsLinea = bufferentrada.readLine()) != null) {
                    String laLinea[] = loStringUtils.splitString(lsLinea,"\\|");
                    if (laUserOptions[0].trim().equals("ALL"))
                        lsReturn += lsLinea;
                    else
                        if (Integer.parseInt(laLinea[0])>=piUsrLevel) {
                            if (piUsrLevel==10) {
                                lsReturn += (loStringUtils.findStrings(laLinea[3],laUserOptions,2))?lsLinea:"";
                            } else if (piUsrLevel==50) {
                                lsReturn += (loStringUtils.findStrings(laLinea[1],laUserOptions,true))?lsLinea:"";
                            } else {
                                lsReturn += (loStringUtils.findStrings(laLinea[3],laUserOptions))?lsLinea:"";
                            }
                        }
                }
            }
            else 
                while ((lsLinea = bufferentrada.readLine()) != null)  lsReturn += lsLinea;
            
            buffersalida.close();
            bufferentrada.close();
        }
        catch (Exception poException) {
            poException.printStackTrace();            
            
            
            
            
            return ("Error");
        }
        return (lsReturn);
    }
    
    void sendPost(String psUrl,String psOptionId) {
        AppParameters loAppParameters = new AppParameters();
        
        String lsReturn = "";
        String lsOrgDis = loAppParameters.msOrgMembersDis; 
        String lsOrgCodes = loAppParameters.msOrgMembers; 
        String lsTime = loAppParameters.msTimeMembersDis; 
        String lsCompany = loAppParameters.msCompany; 
        String lsRegion = loAppParameters.msRegion; 
        String lsZone = loAppParameters.msZone; 
        String lsArea = loAppParameters.msArea; 
        String lsStore = loAppParameters.msStore; 
        String lsExtraOpt1 = loAppParameters.msExtraOpt1; 
        String lsExtraOpt2 = loAppParameters.msExtraOpt2; 
        String lsExtraOpt3 = loAppParameters.msExtraOpt3; 
        String lsExtraOpt4 = loAppParameters.msExtraOpt4; 
        String lsExtraOpt5 = loAppParameters.msExtraOpt5; 
        String lsStatusStore = loAppParameters.msStatusStore;
        String lsOnlyTotals = loAppParameters.msOnlyTotals;
        String lsPresentation = loAppParameters.msPresentation;
        
        String lsClnfiltro = loAppParameters.msClnActivarFiltro;
        String lsItemSelect1 = loAppParameters.msClnItemSelect1;
        String lsItemSelect_02 = loAppParameters.msClnItemSelect2;
        String lsTrxIni = loAppParameters.msClnTrxIni;
        String lsTrxFin = loAppParameters.msClnTrxFin;
        OutputStream loOutputStream;
        
        String lsQryString = "";
        lsQryString += "psOrgDis=" + URLEncoder.encode(lsOrgDis);
        lsQryString += "&psOrgCodes="  + URLEncoder.encode(lsOrgCodes);
        lsQryString += "&psTimeDis="  + URLEncoder.encode(lsTime);
        lsQryString += "&psCompany="  + URLEncoder.encode(lsCompany);
        lsQryString += "&psRegion="  + URLEncoder.encode(lsRegion);
        lsQryString += "&psZone="  + URLEncoder.encode(lsZone);
        lsQryString += "&psArea="  + URLEncoder.encode(lsArea);
        lsQryString += "&psStore="  + URLEncoder.encode(lsStore);
        lsQryString += "&psExtraOption1="  + URLEncoder.encode(lsExtraOpt1);
        lsQryString += "&psExtraOption2="  + URLEncoder.encode(lsExtraOpt2);
        lsQryString += "&psExtraOption3="  + URLEncoder.encode(lsExtraOpt3);
        lsQryString += "&psExtraOption4="  + URLEncoder.encode(lsExtraOpt4);
        lsQryString += "&psExtraOption5="  + URLEncoder.encode(lsExtraOpt5);
        lsQryString += "&psStatusStore="  + URLEncoder.encode(lsStatusStore);
        lsQryString += "&psOnlyTotals="  + URLEncoder.encode(lsOnlyTotals);
        lsQryString += "&psPresentation="  + URLEncoder.encode(lsPresentation);
        lsQryString += "&psOptionId="  + URLEncoder.encode(psOptionId);
        
        try {
            String lsUrl = "http://" + psUrl + msServletName + "?" + lsQryString;
            URL loUrlCnn = new URL(lsUrl);
            loUrlCnn.openConnection();
            BufferedReader loInBuffer = new BufferedReader(new InputStreamReader(loUrlCnn.openStream()));
            loInBuffer.close();
        }
        catch (Exception poException) {
            poException.printStackTrace();
            System.out.println(poException.getMessage());
        }
    }
}

class PopulateOrgTree{
    private String msCurrentPageOpts;
    private String msUserLevel; 
    private String msUserOptions;
    private String msUrl;
    private String msData;
    
    public PopulateOrgTree(String psUrl) {
        msUrl = psUrl;
    }
    
    public PopulateOrgTree(String psUrl, String psUserLevel, String psUserOptions) {
        ServletConnection loOrgInformation = new ServletConnection ();
        msUrl = psUrl;
        msUserLevel = psUserLevel;
        msUserOptions = psUserOptions;
        msData = loOrgInformation.getData("OrganizationYum.txt", msUrl, psUserLevel, psUserOptions);
    }

    public TreeNode createGenericNodesFromStr(String psGenericData, String psAllDescription, String psAllCode) {
        return(createGenericNodes("","", psAllDescription, psAllCode, psGenericData));
    }
    
    public TreeNode createGenericNodes(String psSource, String psAllDescription, String psAllCode) {
        return(createGenericNodes("/servlet/generals.servlets.YumData",psSource, psAllDescription, psAllCode));
    }
    
    public TreeNode createGenericNodes(String psServletName, String psSource, String psAllDescription, String psAllCode) {
        return(createGenericNodes(psServletName, psSource, psAllDescription, psAllCode,""));
    }
    
    public TreeNode createGenericNodes(String psServletName, String psSource, String psAllDescription, String psAllCode, String psGenericData) {
        DefaultMutableTreeNode loRoot = null;
        DefaultMutableTreeNode loLevel1 = null;
        DefaultMutableTreeNode loLevel2 = null;
        DefaultMutableTreeNode loLevel3 = null;
        DefaultMutableTreeNode loLevel4 = null;
        DefaultMutableTreeNode loLevel5 = null;
        StringUtils loStringUtils = new StringUtils();
        String laRptOptions[];
        String lsGenericData;

        ServletConnection loServletConnection = new  ServletConnection(psServletName);
        lsGenericData = (!psGenericData.equals(""))?psGenericData:loServletConnection.getData(psSource,msUrl,"","");

        loRoot = new DefaultMutableTreeNode(new NodeItem(psAllDescription,psAllCode));

        laRptOptions = loStringUtils.splitString(msCurrentPageOpts,",");

        String lsDataTree = "";
        String lsData = lsGenericData;
        String lsDataNodo = "";

        String laTreeYum[];
        if (lsData == null) lsData = "";
        laTreeYum = loStringUtils.splitString(lsData,","); 
        int liTotalMembers = laTreeYum.length - 1;

        for(int liBeginTree=0; liBeginTree<= liTotalMembers; liBeginTree++){
            lsDataTree = laTreeYum[liBeginTree];
            String laNodeTree[]=new String[3];
            laNodeTree = loStringUtils.splitString(lsDataTree,"\\|");

            lsDataNodo = laNodeTree[0].trim();

            if(lsDataNodo.equals("10")){
                loLevel1 = new DefaultMutableTreeNode(new NodeItem(laNodeTree[1], laNodeTree[2]));
                loRoot.add(loLevel1);
            }
            if(lsDataNodo.equals("20")){
                loLevel2 = new DefaultMutableTreeNode(new NodeItem(laNodeTree[1], laNodeTree[2]));
                if (loLevel1==null) loRoot.add(loLevel2); else loLevel1.add(loLevel2);
            }
            if(lsDataNodo.equals("30")){
                loLevel3 = new DefaultMutableTreeNode(new NodeItem(laNodeTree[1], laNodeTree[2]));
                if (loLevel2==null) loRoot.add(loLevel3); else loLevel2.add(loLevel3);
            }
            if(lsDataNodo.equals("40")){
                loLevel4 = new DefaultMutableTreeNode(new NodeItem(laNodeTree[1], laNodeTree[2]));
                if (loLevel3==null) loRoot.add(loLevel4); else loLevel3.add(loLevel4);
            }                
            if(lsDataNodo.equals("50")){
                loLevel5 = new DefaultMutableTreeNode(new NodeItem(laNodeTree[1], laNodeTree[2]));
                if (loLevel4 == null) loRoot.add(loLevel5); else loLevel4.add(loLevel5);
            } 
        } 
        return loRoot;
    }    
    
    public TreeNode createNodes(String psCurrentPageOpts) {
        DefaultMutableTreeNode loRoot = null;
        DefaultMutableTreeNode loCompany = null;
        DefaultMutableTreeNode loRegion = null;
        DefaultMutableTreeNode loZona = null;
        DefaultMutableTreeNode loArea = null;
        DefaultMutableTreeNode loStore = null;
        StringUtils loStringUtils = new StringUtils();
        String laRptOptions[];

        msCurrentPageOpts = psCurrentPageOpts;

        loRoot = new DefaultMutableTreeNode(new NodeItem("Organización",""));
        if (msCurrentPageOpts.equals("")) return(loRoot);

        laRptOptions = loStringUtils.splitString(msCurrentPageOpts,",");

        String lsDataTree = "";
        String lsData = msData;
        String lsDataNodo = "";

        String laTreeYum[];
        if (lsData == null) lsData = "";
        laTreeYum = loStringUtils.splitString(lsData,",");
        int liTotalMembers = laTreeYum.length -1;

        for(int liBeginTree=0; liBeginTree<= liTotalMembers; liBeginTree++){
            lsDataTree = laTreeYum[liBeginTree];
            String laNodeTree[]=new String[3];
            laNodeTree = loStringUtils.splitString(lsDataTree,"\\|");

            lsDataNodo = laNodeTree[0].trim();

            if(lsDataNodo.equals("10")){
                if (!loStringUtils.findStrings(laNodeTree[3],laRptOptions,2)) continue;
                loCompany = new DefaultMutableTreeNode(new NodeItem(laNodeTree[2], laNodeTree[3]));
                loRoot.add(loCompany);
            }
            if(lsDataNodo.equals("20")){
                if (!loStringUtils.findStrings(laNodeTree[3],laRptOptions,2)) continue;
                loRegion = new DefaultMutableTreeNode(new NodeItem(laNodeTree[2], laNodeTree[3]));
                if (loCompany==null) loRoot.add(loRegion); else loCompany.add(loRegion);
            }
            if(lsDataNodo.equals("30")){
                if (!loStringUtils.findStrings(laNodeTree[3],laRptOptions,2)) continue;
                loZona = new DefaultMutableTreeNode(new NodeItem(laNodeTree[2], laNodeTree[3]));
                if (loRegion==null) loRoot.add(loZona); else loRegion.add(loZona);
            }
            if(lsDataNodo.equals("40")){
                if (!loStringUtils.findStrings(laNodeTree[3],laRptOptions,2)) continue;
                loArea = new DefaultMutableTreeNode(new NodeItem(laNodeTree[2], laNodeTree[3]));
                if (loZona==null) loRoot.add(loArea); else loZona.add(loArea);
            }                
            if(lsDataNodo.equals("50")){
                if (!loStringUtils.findStrings(laNodeTree[3],laRptOptions,2)) continue;
                loStore = new DefaultMutableTreeNode(new NodeItem(laNodeTree[2], laNodeTree[3]));
                if (loArea == null) loRoot.add(loStore); else loArea.add(loStore);
            } 
        } 
        return loRoot;
    }
}

class PopulateTimeTree{
    private String msUrl;
    private String msCurrentPageOpts;
    private String msData;

    public PopulateTimeTree(String psUrl) {
        msUrl = psUrl;
        ServletConnection loTimeInformation = new ServletConnection();
        msData = loTimeInformation.getData("TimeYum.txt", msUrl,"","");
    }
    
    public TreeNode createNodes(String psCurrentPageOpts) {
        StringUtils loStringUtils = new StringUtils();
        DefaultMutableTreeNode loRootTime;
        DefaultMutableTreeNode loYear = null;
        DefaultMutableTreeNode loQuarter = null;
        DefaultMutableTreeNode loMonth = null;
        DefaultMutableTreeNode loWeek = null;
        DefaultMutableTreeNode loDay = null;
        String laRptOptions[];
        int piTimeLevel;
        
        msCurrentPageOpts = psCurrentPageOpts;
        
        loRootTime = new DefaultMutableTreeNode(new NodeItem("Tiempo",""));
        if (msCurrentPageOpts.equals("")) return(loRootTime);
        
        laRptOptions = loStringUtils.splitString(msCurrentPageOpts,",");
        piTimeLevel = Integer.parseInt(laRptOptions[0]);

        String lsData = msData;
        
        String lsDataTree = "";
        String lsDataNodo = "";
        String laTreeTime[];
        laTreeTime = loStringUtils.splitString(lsData, ",");
        int liTotalMembers = laTreeTime.length -1;

        for(int liBeginTree=0; liBeginTree <= liTotalMembers; liBeginTree++){
            lsDataTree = laTreeTime[liBeginTree];
            String laNodeTree[]=new String[2];
            laNodeTree = loStringUtils.splitString(lsDataTree, "\\|");
            lsDataNodo = laNodeTree[1].trim();
            
            if (Integer.parseInt(lsDataNodo)>piTimeLevel) continue;

            //Año
            if(lsDataNodo.equals("10")) {
                loYear = new DefaultMutableTreeNode(new NodeItem(laNodeTree[0],laNodeTree[2]));
                loRootTime.add(loYear);
            }
            //Cuarto
            if(lsDataNodo.equals("20")){
                loQuarter = new DefaultMutableTreeNode(new NodeItem(laNodeTree[0],laNodeTree[2]));
                loYear.add(loQuarter);
            }
            
            //Periodo
            if(lsDataNodo.equals("30")){
                loMonth = new DefaultMutableTreeNode(new NodeItem(laNodeTree[0],laNodeTree[2]));
                loQuarter.add(loMonth);
            }
            //Semana
            if(lsDataNodo.equals("40")){
                loWeek = new DefaultMutableTreeNode(new NodeItem(laNodeTree[0],laNodeTree[2]));
                loMonth.add(loWeek);
            }
            //dia
            if(lsDataNodo.equals("50")){
                loDay = new DefaultMutableTreeNode(new NodeItem(laNodeTree[0],laNodeTree[2]));
                loWeek.add(loDay);
            }
        }
        return loRootTime;
    }
}


class NodeItem{
    private String msDisplay;
    private String msCveObj;
    
    public NodeItem(String psDisplay, String psCveObj){
        this.msDisplay = psDisplay; 
        this.msCveObj = psCveObj;
    }
    public String getText(){
        return msDisplay;
    }
    public String getCode(){
        return msCveObj;
    }
    
    public String toString(){
        return msDisplay;
    }
}

class AppParameters {
    public static String msOrgMembers = "";
    public static String msTimeMembers = "";
    public static String msOrgMembersDis = "";
    public static String msTimeMembersDis = "";
    public static String msWorkMembers = "";
    public static String msWorkMembersDis = "";
    public static String msCompany="1";
    public static String msRegion="0";
    public static String msZone="0";
    public static String msArea="0";
    public static String msStore="0";
    public static String msExtraOpt1="0"; 
    public static String msExtraOpt2="0";
    public static String msExtraOpt3="0";
    public static String msExtraOpt4="0";
    public static String msExtraOpt5="0";
    public static String msExtraOpt6="0";
    public static String msStatusStore="T";
    public static String msOnlyTotals="0";
    public static String msClnItemSelect1="";
    public static String msClnItemSelect2="";
    public static String msClnTrxIni="1";
    public static String msClnTrxFin="100";
    public static String msClnActivarFiltro="0";
    
    public static String msPresentation = "VIEWPORT";
    public static String msTmpString = "";
    public static String msOrganization = "";
    public static String msTime = "";
    
    public void setOrgParameters(String psOrgMembersDis,String psOrgMembers) {
        msOrgMembers = psOrgMembers;
        msOrgMembersDis = psOrgMembersDis;
    }
    
    public void setTimeParameters(String psTimeMembersDis,String psTimeMembers) {
        msTimeMembers = psTimeMembers;
        msTimeMembersDis = psTimeMembersDis;
    }
}

class StringForSelection {
    private AppParameters moAppValues = new AppParameters();
    private String msWorkStringDis;
    private String msWorkStringCodes;
        
    public NodeItem findSelectedNodes(JTree poTreeFind) {
        TreePath[] laPaths = poTreeFind.getSelectionPaths();
        StringUtils loStringUtils = new StringUtils();
        String lsFinalStringDis = "";
        String lsFinalStringCodes = "";
        TreePath loActualPathSend;
        DefaultMutableTreeNode loNode;
        Object loNodeInfoOrg;
        NodeItem loNodeItem;
        
        if (laPaths==null) return(null);
        
        loActualPathSend = (TreePath)laPaths[0];
        loNode = (DefaultMutableTreeNode)loActualPathSend.getLastPathComponent();
        loNodeInfoOrg = loNode.getUserObject();
        loNodeItem  = (NodeItem)loNodeInfoOrg;
        
        if (laPaths.length == 1 && laPaths[0].getParentPath()==null  && loNodeItem.getCode().equals("")) return(null);
       
        String lsCadFinal = "";
        for (int li = 0; li <= laPaths.length-1; li++)
        {
            if (laPaths[li].getParentPath()==null && loNodeItem.getCode().equals("")) continue;
            loActualPathSend = (TreePath)laPaths[li];
            loNode = (DefaultMutableTreeNode)loActualPathSend.getLastPathComponent();
            loNodeInfoOrg = loNode.getUserObject();
            loNodeItem  = (NodeItem)loNodeInfoOrg;
            
            lsFinalStringDis +=loNodeItem.getText() + ",";
            lsFinalStringCodes +=loNodeItem.getCode() + ",";
        }
        lsFinalStringDis = lsFinalStringDis.substring(0, lsFinalStringDis.length()-1);
        lsFinalStringCodes = lsFinalStringCodes.substring(0, lsFinalStringCodes.length()-1);
        return(new NodeItem(lsFinalStringDis,lsFinalStringCodes));
    }
 
    public void visitAllParents(JTree tree, TreePath parent){
        TreeNode node = (TreeNode)parent.getLastPathComponent();
        DefaultMutableTreeNode node1 = (DefaultMutableTreeNode)parent.getLastPathComponent();
       
        if(!node1.isRoot()){
            TreeNode padre = node.getParent() ;
            Object loNodeInfoOrg = node1.getUserObject();
            NodeItem infoNode  = (NodeItem)loNodeInfoOrg;
            msWorkStringDis = msWorkStringDis + "[" + infoNode.getText() + "].";
            msWorkStringCodes = msWorkStringCodes + "&[" + infoNode.getCode() + "].";
            visitAllParents(tree, parent.getParentPath());
        }
    }
}

class StringUtils {
    public static String[] splitString(String psString, String psDelimiter) {
        String loArray[];
        int liCounter = 0;
        
        if (psString == null || psDelimiter == null) return (null); 
       
        StringTokenizer loTokens = new StringTokenizer(psString, psDelimiter);
        loArray = new String[loTokens.countTokens()];
        
        while (loTokens.hasMoreElements()) {
            loArray[liCounter++] = (String)loTokens.nextToken();
        }
        return (loArray);
    }
    
    public boolean findStrings(String psSource, String paSearches[]) {
        for (int li = 0; li < paSearches.length; li++)
            if (psSource.indexOf(paSearches[li])!=-1) return(true);
        return(false);
    }
    
    public boolean findStrings(String psSource, String paSearches[], int piPos) {
        for (int li = 0; li < paSearches.length; li++)
            if (psSource.indexOf(paSearches[li])==piPos) return(true);
        return(false);
    }
    
    public boolean findStrings(String psSource, String paSearches[], boolean pbEquals) {
        for (int li = 0; li < paSearches.length; li++)
            if (psSource.equals(paSearches[li])==pbEquals) return(true);
        return(false);
    }
}

