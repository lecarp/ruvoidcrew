import { useState } from 'react';
import {
  Box,
  Button,
  Flex,
  Icon,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { useBackend } from '../../tgui/backend';
import { Window } from '../../tgui/layouts';

interface ShipEntry {
  id: string;
  name: string;
  hull_class: string;
  hull_id: string;
  mass: number;
  credits: number;
  items_count: number;
  status: 'stored' | 'deployed';
  saved_date: string;
}

interface BerthShip {
  name: string;
  captain: string;
  integrity: number;
  items_count: number;
}

interface HangarData {
  is_concourse: boolean;
  berth_number: number;
  has_ship: boolean;
  berth_ship: BerthShip | null;
  is_captain: boolean;
  ships: ShipEntry[];
  slots_used: number;
  max_slots: number;
  selected_ship_id: string;
  selected_ship: ShipEntry | null;
}

export const OutpostShipHangar = () => {
  const { act, data } = useBackend<HangarData>();
  const {
    is_concourse,
    berth_number,
    has_ship,
    berth_ship,
    is_captain,
    ships = [],
    slots_used = 0,
    max_slots = 5,
    selected_ship_id,
    selected_ship,
  } = data;

  const activeShip = selected_ship || (ships.length > 0 ? ships[0] : null);

  return (
    <Window title="Консоль ангара // Hangar Terminal" width={920} height={660}>
      <Window.Content className="Helm" style={{ padding: '0', display: 'flex', flexDirection: 'column' }}>
        
        {/* TOP RAIL */}
        <Box
          style={{
            padding: '10px 16px',
            backgroundColor: '#111719',
            borderBottom: '1px solid #2d383c',
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
          }}
        >
          <Box>
            <Box
              style={{
                fontFamily: 'monospace',
                fontWeight: 'bold',
                fontSize: '13px',
                color: '#f5f8ff',
                letterSpacing: '0.12em',
              }}
            >
              OUTPOST HANGAR TERMINAL // {is_concourse ? 'CONCOURSE LOBBY' : `BERTH ${berth_number}`}
            </Box>
            <Box
              style={{
                fontFamily: 'monospace',
                fontSize: '10px',
                color: '#7d8f94',
                marginTop: '2px',
              }}
            >
              STATION DOCK SYSTEM • TRADER OUTPOST • SECTOR GRID 14-8
            </Box>
          </Box>

          <Box
            style={{
              fontFamily: 'monospace',
              fontSize: '11px',
              color: '#5a7378',
              letterSpacing: '0.08em',
            }}
          >
            SYS: ONLINE // READY
          </Box>
        </Box>

        {/* MAIN BODY GRID */}
        <Box style={{ flex: 1, padding: '12px', display: 'flex', gap: '12px', overflow: 'hidden' }}>
          
          {/* LEFT COLUMN: BERTH STATUS & REGISTER */}
          <Box style={{ width: '40%', display: 'flex', flexDirection: 'column', gap: '12px' }}>
            
            {/* WELL 1: ACTIVE BERTH MANIFEST */}
            <Box
              style={{
                backgroundColor: '#05090a',
                border: '1px solid #000',
                borderRadius: '3px',
                boxShadow: 'inset 0 2px 4px rgba(0,0,0,0.9)',
                overflow: 'hidden',
              }}
            >
              <Box
                style={{
                  padding: '6px 10px',
                  backgroundColor: '#0e1619',
                  borderBottom: '1px solid #1a2529',
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                }}
              >
                <Box style={{ fontSize: '11px', fontWeight: 'bold', color: '#7d8f94', textTransform: 'uppercase' }}>
                  {is_concourse ? 'Вестибюль аванпоста' : `Сейчас на причале ${berth_number}`}
                </Box>
                <Box
                  style={{
                    fontFamily: 'monospace',
                    fontSize: '10px',
                    color: has_ship ? '#59b871' : '#7d8f94',
                  }}
                >
                  {has_ship ? 'БОРТ ЗАФИКСИРОВАН' : 'ПРИЧАЛ СВОБОДЕН'}
                </Box>
              </Box>

              <Box style={{ padding: '10px' }}>
                {has_ship && berth_ship ? (
                  <Stack vertical g={1.5}>
                    <Flex justify="space-between" align="center">
                      <Box color="#7d8f94" fontSize="11px">КОРАБЛЬ:</Box>
                      <Box color="#f2a341" bold fontSize="12px" fontFamily="monospace">
                        {berth_ship.name}
                      </Box>
                    </Flex>

                    <Flex justify="space-between" align="center">
                      <Box color="#7d8f94" fontSize="11px">КАПИТАН:</Box>
                      <Box color="#74c8dd" fontSize="11px" fontFamily="monospace">
                        {berth_ship.captain}
                      </Box>
                    </Flex>

                    <Box>
                      <Flex justify="space-between" align="center" mb={0.5}>
                        <Box color="#7d8f94" fontSize="10px">ЦЕЛОСТНОСТЬ КОРПУСА:</Box>
                        <Box color="#59b871" fontSize="10px" fontFamily="monospace">
                          {berth_ship.integrity}% [OK]
                        </Box>
                      </Flex>
                      <ProgressBar
                        value={berth_ship.integrity / 100}
                        color="good"
                        style={{ height: '8px' }}
                      />
                    </Box>

                    <Box style={{ borderTop: '1px solid #1a2428', paddingTop: '6px' }}>
                      <Flex justify="space-between" align="center">
                        <Box color="#7d8f94" fontSize="11px">ВЕЩИ НА БОРТУ:</Box>
                        <Box color="#f2a341" bold fontSize="12px" fontFamily="monospace">
                          {berth_ship.items_count} объекта
                        </Box>
                      </Flex>
                    </Box>
                  </Stack>
                ) : (
                  <Box color="#7d8f94" fontSize="11px" textAlign="center" py={2}>
                    {is_concourse
                      ? 'Выберите судно из реестра для выгрузки на новый причал.'
                      : 'Причал свободен для посадки или развертывания.'}
                  </Box>
                )}
              </Box>
            </Box>

            {/* WELL 2: HANGAR REGISTER */}
            <Box
              style={{
                flex: 1,
                backgroundColor: '#05090a',
                border: '1px solid #000',
                borderRadius: '3px',
                boxShadow: 'inset 0 2px 4px rgba(0,0,0,0.9)',
                display: 'flex',
                flexDirection: 'column',
                overflow: 'hidden',
              }}
            >
              <Box
                style={{
                  padding: '6px 10px',
                  backgroundColor: '#0e1619',
                  borderBottom: '1px solid #1a2529',
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                }}
              >
                <Box style={{ fontSize: '11px', fontWeight: 'bold', color: '#7d8f94', textTransform: 'uppercase' }}>
                  РЕЕСТР АНГАРА
                </Box>
                <Box style={{ fontFamily: 'monospace', fontSize: '10px', color: '#74c8dd' }}>
                  СЛОТЫ: {slots_used} / {max_slots}
                </Box>
              </Box>

              <Box style={{ flex: 1, padding: '8px', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: '8px' }}>
                {ships.length === 0 ? (
                  <Box color="#607580" fontSize="11px" textAlign="center" py={3}>
                    [ АНГАР ПУСТ ]
                  </Box>
                ) : (
                  ships.map((ship) => {
                    const isSelected = activeShip?.id === ship.id;
                    const isDeployed = ship.status === 'deployed';

                    return (
                      <Box
                        key={ship.id}
                        onClick={() => act('select', { id: ship.id })}
                        style={{
                          padding: '8px 10px',
                          backgroundColor: isSelected ? '#121d22' : '#090d0e',
                          border: `1px solid ${isSelected ? '#74c8dd' : '#1b2529'}`,
                          borderRadius: '3px',
                          cursor: 'pointer',
                          transition: 'all 0.15s ease',
                        }}
                      >
                        <Flex justify="space-between" align="center" mb={0.5}>
                          <Box
                            style={{
                              fontFamily: 'monospace',
                              fontWeight: 'bold',
                              fontSize: '11px',
                              color: isSelected ? '#ffffff' : '#cfd8dc',
                              letterSpacing: '0.05em',
                            }}
                          >
                            {ship.name.toUpperCase()}
                          </Box>
                          <Box
                            style={{
                              fontSize: '9px',
                              padding: '1px 5px',
                              borderRadius: '2px',
                              fontFamily: 'monospace',
                              backgroundColor: isDeployed ? 'rgba(242, 163, 65, 0.15)' : 'rgba(89, 184, 113, 0.15)',
                              color: isDeployed ? '#f2a341' : '#59b871',
                              border: `1px solid ${isDeployed ? 'rgba(242, 163, 65, 0.4)' : 'rgba(89, 184, 113, 0.4)'}`,
                            }}
                          >
                            {isDeployed ? 'НА ПРИЧАЛЕ' : 'В АНГАРЕ'}
                          </Box>
                        </Flex>

                        <Flex justify="space-between" style={{ fontSize: '10px', color: '#7d8f94', fontFamily: 'monospace' }}>
                          <Box>Корпус: {ship.hull_class}</Box>
                          <Box>Масса: {ship.mass} т</Box>
                        </Flex>
                      </Box>
                    );
                  })
                )}
              </Box>
            </Box>

          </Box>

          {/* RIGHT COLUMN: BLUEPRINT & OPERATIONS */}
          <Box style={{ width: '60%', display: 'flex', flexDirection: 'column', gap: '12px' }}>
            
            {/* WELL 3: BLUEPRINT SCHEMATIC VIEW */}
            <Box
              style={{
                flex: 1,
                backgroundColor: '#05090a',
                border: '1px solid #000',
                borderRadius: '3px',
                boxShadow: 'inset 0 2px 4px rgba(0,0,0,0.9)',
                display: 'flex',
                flexDirection: 'column',
                overflow: 'hidden',
              }}
            >
              <Box
                style={{
                  padding: '6px 10px',
                  backgroundColor: '#0e1619',
                  borderBottom: '1px solid #1a2529',
                }}
              >
                <Box style={{ fontSize: '11px', fontWeight: 'bold', color: '#7d8f94', textTransform: 'uppercase' }}>
                  СХЕМА СУДНА // {activeShip ? activeShip.name.toUpperCase() : 'НЕТ ВЫБОРА'}
                </Box>
              </Box>

              {/* RADAR BLUEPRINT CANVAS */}
              <Box
                style={{
                  flex: 1,
                  position: 'relative',
                  backgroundColor: '#040708',
                  backgroundImage: 'radial-gradient(circle, #0e1a1e 1px, transparent 1px)',
                  backgroundSize: '16px 16px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  overflow: 'hidden',
                  minHeight: '220px',
                }}
              >
                {/* Radar Concentric Rings */}
                <Box
                  style={{
                    position: 'absolute',
                    width: '200px',
                    height: '200px',
                    borderRadius: '50%',
                    border: '1px solid #142227',
                    pointerEvents: 'none',
                  }}
                />
                <Box
                  style={{
                    position: 'absolute',
                    width: '320px',
                    height: '320px',
                    borderRadius: '50%',
                    border: '1px solid #0e171b',
                    pointerEvents: 'none',
                  }}
                />

                {/* Radar Crosshairs */}
                <Box style={{ position: 'absolute', width: '100%', height: '1px', backgroundColor: '#101c20' }} />
                <Box style={{ position: 'absolute', height: '100%', width: '1px', backgroundColor: '#101c20' }} />

                {/* Tactical Ship Silhouette/Icon */}
                <Box style={{ position: 'relative', zIndex: 1, textAlign: 'center' }}>
                  <Icon
                    name="space-shuttle"
                    size={6}
                    style={{
                      color: '#74c8dd',
                      filter: 'drop-shadow(0 0 16px rgba(116, 200, 221, 0.45))',
                    }}
                  />
                  <Box
                    style={{
                      fontFamily: 'monospace',
                      fontSize: '11px',
                      color: '#74c8dd',
                      marginTop: '8px',
                      letterSpacing: '0.1em',
                    }}
                  >
                    {activeShip ? activeShip.name : 'ВЫБЕРИТЕ КОРАБЛЬ'}
                  </Box>
                </Box>
              </Box>

              {/* 4-COLUMN METRICS READOUT */}
              <Box
                style={{
                  padding: '10px 14px',
                  backgroundColor: '#0a0f11',
                  borderTop: '1px solid #1a2529',
                  display: 'grid',
                  gridTemplateColumns: 'repeat(4, 1fr)',
                  gap: '12px',
                }}
              >
                <Box>
                  <Box style={{ color: '#7d8f94', fontSize: '10px', textTransform: 'uppercase' }}>КЛАСС КОРПУСА</Box>
                  <Box style={{ color: '#74c8dd', fontWeight: 'bold', fontSize: '12px', fontFamily: 'monospace', marginTop: '2px' }}>
                    {activeShip?.hull_class || '—'}
                  </Box>
                </Box>

                <Box>
                  <Box style={{ color: '#7d8f94', fontSize: '10px', textTransform: 'uppercase' }}>МАССА</Box>
                  <Box style={{ color: '#f2a341', fontWeight: 'bold', fontSize: '12px', fontFamily: 'monospace', marginTop: '2px' }}>
                    {activeShip?.mass ? `${activeShip.mass} т` : '—'}
                  </Box>
                </Box>

                <Box>
                  <Box style={{ color: '#7d8f94', fontSize: '10px', textTransform: 'uppercase' }}>СУДОВАЯ КАЗНА</Box>
                  <Box style={{ color: '#f2a341', fontWeight: 'bold', fontSize: '12px', fontFamily: 'monospace', marginTop: '2px' }}>
                    {activeShip?.credits !== undefined ? `${activeShip.credits.toLocaleString()} Кр` : '0 Кр'}
                  </Box>
                </Box>

                <Box>
                  <Box style={{ color: '#7d8f94', fontSize: '10px', textTransform: 'uppercase' }}>ВЕЩИ НА БОРТУ</Box>
                  <Box style={{ color: '#59b871', fontWeight: 'bold', fontSize: '12px', fontFamily: 'monospace', marginTop: '2px' }}>
                    {activeShip?.items_count !== undefined ? `${activeShip.items_count} объекта` : '0 объекта'}
                  </Box>
                </Box>
              </Box>
            </Box>

            {/* WELL 4: OPERATIONS CONSOLE */}
            <Box
              style={{
                backgroundColor: '#05090a',
                border: '1px solid #000',
                borderRadius: '3px',
                boxShadow: 'inset 0 2px 4px rgba(0,0,0,0.9)',
                padding: '10px',
              }}
            >
              <Box
                style={{
                  fontSize: '10px',
                  fontWeight: 'bold',
                  color: '#7d8f94',
                  textTransform: 'uppercase',
                  marginBottom: '8px',
                  letterSpacing: '0.08em',
                }}
              >
                ПАНЕЛЬ ОПЕРАЦИЙ // CONTROL DECK
              </Box>

              <Box style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '10px' }}>
                
                {/* BUTTON 1: ПЕРЕМЕСТИТЬ В АНГАР */}
                <Tooltip
                  content={
                    is_concourse
                      ? 'Перемещение доступно только на причале'
                      : !has_ship
                      ? 'На причале нет корабля'
                      : !is_captain
                      ? 'Только капитан судна может переместить его в ангар'
                      : 'Переместить корабль со всеми предметами в ангар'
                  }
                >
                  <Box
                    onClick={() => {
                      if (!is_concourse && has_ship && is_captain) {
                        act('store');
                      }
                    }}
                    style={{
                      padding: '10px',
                      borderRadius: '3px',
                      textAlign: 'center',
                      cursor: !is_concourse && has_ship && is_captain ? 'pointer' : 'not-allowed',
                      backgroundColor: !is_concourse && has_ship && is_captain ? '#251b0f' : '#101416',
                      border: `1px solid ${!is_concourse && has_ship && is_captain ? '#f2a341' : '#273439'}`,
                      opacity: !is_concourse && has_ship && is_captain ? 1 : 0.45,
                      transition: 'all 0.15s ease',
                    }}
                  >
                    <Box
                      style={{
                        fontFamily: 'monospace',
                        fontWeight: 'bold',
                        fontSize: '12px',
                        color: !is_concourse && has_ship && is_captain ? '#f2a341' : '#7d8f94',
                        letterSpacing: '0.05em',
                      }}
                    >
                      ПЕРЕМЕСТИТЬ В АНГАР
                    </Box>
                    <Box
                      style={{
                        fontFamily: 'monospace',
                        fontSize: '10px',
                        color: !is_concourse && has_ship && is_captain ? '#8a5f26' : '#556569',
                        marginTop: '3px',
                      }}
                    >
                      вещи будут сохранены
                    </Box>
                  </Box>
                </Tooltip>

                {/* BUTTON 2: ДОСТАТЬ НА ПРИЧАЛ */}
                <Tooltip
                  content={
                    !activeShip
                      ? 'Выберите корабль из списка'
                      : activeShip.status === 'deployed'
                      ? 'Этот корабль уже находится на причале'
                      : !is_concourse && has_ship
                      ? 'Текущий причал уже занят'
                      : 'Выгрузить корабль на причал'
                  }
                >
                  <Box
                    onClick={() => {
                      if (activeShip && activeShip.status !== 'deployed' && (is_concourse || !has_ship)) {
                        act('deploy', { id: activeShip.id });
                      }
                    }}
                    style={{
                      padding: '10px',
                      borderRadius: '3px',
                      textAlign: 'center',
                      cursor: activeShip && activeShip.status !== 'deployed' && (is_concourse || !has_ship) ? 'pointer' : 'not-allowed',
                      backgroundColor: activeShip && activeShip.status !== 'deployed' && (is_concourse || !has_ship) ? '#0e1d16' : '#101416',
                      border: `1px solid ${activeShip && activeShip.status !== 'deployed' && (is_concourse || !has_ship) ? '#59b871' : '#273439'}`,
                      opacity: activeShip && activeShip.status !== 'deployed' && (is_concourse || !has_ship) ? 1 : 0.45,
                      transition: 'all 0.15s ease',
                    }}
                  >
                    <Box
                      style={{
                        fontFamily: 'monospace',
                        fontWeight: 'bold',
                        fontSize: '12px',
                        color: activeShip && activeShip.status !== 'deployed' && (is_concourse || !has_ship) ? '#59b871' : '#7d8f94',
                        letterSpacing: '0.05em',
                      }}
                    >
                      ДОСТАТЬ НА ПРИЧАЛ
                    </Box>
                    <Box
                      style={{
                        fontFamily: 'monospace',
                        fontSize: '10px',
                        color: activeShip && activeShip.status !== 'deployed' && (is_concourse || !has_ship) ? '#2e6b3f' : '#556569',
                        marginTop: '3px',
                      }}
                    >
                      {activeShip?.status === 'deployed' ? 'УЖЕ НА ПРИЧАЛЕ' : 'Выгрузить из ангара'}
                    </Box>
                  </Box>
                </Tooltip>

                {/* BUTTON 3: ТРЮМ */}
                <Box
                  onClick={() => act('cargo')}
                  style={{
                    padding: '10px',
                    borderRadius: '3px',
                    textAlign: 'center',
                    cursor: 'pointer',
                    backgroundColor: '#0d1a1e',
                    border: '1px solid #74c8dd',
                    transition: 'all 0.15s ease',
                  }}
                >
                  <Box
                    style={{
                      fontFamily: 'monospace',
                      fontWeight: 'bold',
                      fontSize: '12px',
                      color: '#74c8dd',
                      letterSpacing: '0.05em',
                    }}
                  >
                    ТРЮМ
                  </Box>
                  <Box
                    style={{
                      fontFamily: 'monospace',
                      fontSize: '10px',
                      color: '#3d6a76',
                      marginTop: '3px',
                    }}
                  >
                    Список сохранённых вещей
                  </Box>
                </Box>

              </Box>
            </Box>

          </Box>

        </Box>

        {/* BOTTOM HAZARD STRIPING */}
        <Box
          className="Helm__hazard"
          style={{
            height: '8px',
            opacity: 0.75,
            background: 'repeating-linear-gradient(-45deg, #d9a230 0 10px, #14181a 10px 20px)',
          }}
        />

      </Window.Content>
    </Window>
  );
};

