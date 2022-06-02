import React from 'react'
import {useTable, useFilters, useGlobalFilter, useAsyncDebounce, useSortBy, usePagination} from 'react-table'
import {ChevronDoubleLeftIcon, ChevronLeftIcon, ChevronRightIcon, ChevronDoubleRightIcon} from '@heroicons/react/solid'
import {Button, PageButton} from './shared/Button'
import {classNames} from './shared/Utils'
import {SortIcon, SortUpIcon, SortDownIcon} from './shared/Icons'
import {useState} from 'react'
import {SelectBox} from "./selectBox";

// Define a default UI for filtering
function GlobalFilter({
                          preGlobalFilteredRows,
                          globalFilter,
                          setGlobalFilter,
                      }) {
    const count = preGlobalFilteredRows.length
    const [value, setValue] = React.useState(globalFilter)
    const onChange = useAsyncDebounce(value => {
        setGlobalFilter(value || undefined)
    }, 200)

    return (
        <div className="mt-1 flex rounded-md shadow-sm w-full">
                <span
                    className="inline-flex items-center px-7 rounded-l-md border border-gray-300 bg-gray-50 text-gray-800 text-sm w-24 h-12">
                  Search
                </span>
            <input
                type="text"
                className="px-6 focus:ring-indigo-500 focus:border-indigo-500 block rounded-none rounded-r-md sm:text-sm border-gray-300 w-full h-12"
                value={value || ""}
                onChange={e => {
                    setValue(e.target.value);
                    onChange(e.target.value);
                }}
                placeholder={`${count} records...`}
            />
        </div>
    )
}

export function StatusPill({value}) {
    const status = value ? value.toLowerCase() : "unknown";

    return (
        <span
            className={
                classNames(
                    "px-3 py-1 uppercase leading-wide font-bold text-xs rounded-full shadow-sm",
                    status.startsWith("한겨레") ? "bg-green-100 text-green-800" : null,
                    status.startsWith("동아일보") ? "bg-yellow-100 text-yellow-800" : null,
                    status.startsWith("offline") ? "bg-red-100 text-red-800" : null,
                )
            }
        >
      {status}
    </span>
    );
}

export function AvatarCell({value, column, row}) {
    return (
        <div className="flex items-center">
            <div>
                <div className="cursor-pointer text-sm font-medium text-gray-900"
                     onClick={() => window.open(row.original[column.emailAccessor])}>{value}</div>
                {/*<div className="text-sm text-gray-500">{row.original[column.emailAccessor]}</div>*/}
            </div>
        </div>
    )
}

function Table({columns, data}) {
    // Use the state and functions returned from useTable to build your UI
    const {
        getTableProps,
        getTableBodyProps,
        headerGroups,
        prepareRow,
        page, // Instead of using 'rows', we'll use page,
        // which has only the rows for the active page

        // The rest of these things are super handy, too ;)
        canPreviousPage,
        canNextPage,
        pageOptions,
        pageCount,
        gotoPage,
        nextPage,
        previousPage,
        setPageSize,

        state,
        preGlobalFilteredRows,
        setGlobalFilter,
    } = useTable({
            columns,
            data,
        },
        useFilters, // useFilters!
        useGlobalFilter,
        useSortBy,
        usePagination,  // new
    )

    // Render the UI for your table
    return (
        <>
            <div className="sm:flex sm:gap-x-2">
                <GlobalFilter
                    preGlobalFilteredRows={preGlobalFilteredRows}
                    globalFilter={state.globalFilter}
                    setGlobalFilter={setGlobalFilter}
                />
                {headerGroups.map((headerGroup) =>
                    headerGroup.headers.map((column) =>
                        column.Filter ? (
                            <div className="mt-2 sm:mt-0" key={column.id}>
                                {column.render("Filter")}
                            </div>
                        ) : null
                    )
                )}
            </div>
            {/* table */}
            <div className="mt-4 flex flex-col">
                <div className="-my-2 overflow-x-auto -mx-4 sm:-mx-6 lg:-mx-8">
                    <div className="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
                        <div className="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
                            <table {...getTableProps()} className="min-w-full divide-y divide-gray-200">
                                <thead className="bg-gray-50">
                                {headerGroups.map(headerGroup => (
                                    <tr {...headerGroup.getHeaderGroupProps()}>
                                        {headerGroup.headers.map(column => (
                                            // Add the sorting props to control sorting. For this example
                                            // we can add them into the header props
                                            <th
                                                scope="col"
                                                className="group px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                                                {...column.getHeaderProps(column.getSortByToggleProps())}
                                            >
                                                <div className="flex items-center justify-between">
                                                    {column.render('Header')}
                                                    {/* Add a sort direction indicator */}
                                                    <span>
                                                      {column.isSorted
                                                          ? column.isSortedDesc
                                                              ? <SortDownIcon className="w-4 h-4 text-gray-400"/>
                                                              : <SortUpIcon className="w-4 h-4 text-gray-400"/>
                                                          : (
                                                              <SortIcon className="w-4 h-4 text-gray-400 opacity-0 group-hover:opacity-100"/>
                                                          )}
                                                    </span>
                                                </div>
                                            </th>
                                        ))}
                                    </tr>
                                ))}
                                </thead>
                                <tbody
                                    {...getTableBodyProps()}
                                    className="bg-white divide-y divide-gray-200"
                                >
                                {page.map((row) => {  // new
                                    prepareRow(row)
                                    return (
                                        <tr {...row.getRowProps()}>
                                            {row.cells.map(cell => {
                                                return (
                                                    <td
                                                        {...cell.getCellProps()}
                                                        className="px-6 py-4"
                                                        role="cell"
                                                    >
                                                        {cell.column.Cell.name === "defaultRenderer"
                                                            ? <div
                                                                className="text-sm text-black-500">{cell.render('Cell')}</div>
                                                            : cell.render('Cell')
                                                        }
                                                    </td>
                                                )
                                            })}
                                        </tr>
                                    )
                                })}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            {/* Pagination */}
            <div className="py-3 flex items-center justify-between">
                <div className="flex-1 flex justify-between sm:hidden">
                    <Button onClick={() => previousPage()} disabled={!canPreviousPage}>Previous</Button>
                    <Button onClick={() => nextPage()} disabled={!canNextPage}>Next</Button>
                </div>
                <div className="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                    <div className="flex gap-x-2 items-baseline">
                        <span className="text-sm text-gray-700">
                          Page <span className="font-medium">{state.pageIndex + 1}</span> of <span
                            className="font-medium">{pageOptions.length}</span>
                        </span>
                        <SelectBox selected={state.pageSize} setSelected={(value)=>setPageSize(Number(value))}/>
                    </div>
                    <div>
                        <nav className="relative z-0 inline-flex rounded-md shadow-sm -space-x-px"
                             aria-label="Pagination">
                            <PageButton
                                className="rounded-l-md"
                                onClick={() => gotoPage(0)}
                                disabled={!canPreviousPage}
                            >
                                <span className="sr-only">First</span>
                                <ChevronDoubleLeftIcon className="h-5 w-5 text-gray-400" aria-hidden="true"/>
                            </PageButton>
                            <PageButton
                                onClick={() => previousPage()}
                                disabled={!canPreviousPage}
                            >
                                <span className="sr-only">Previous</span>
                                <ChevronLeftIcon className="h-5 w-5 text-gray-400" aria-hidden="true"/>
                            </PageButton>
                            <PageButton
                                onClick={() => nextPage()}
                                disabled={!canNextPage
                                }>
                                <span className="sr-only">Next</span>
                                <ChevronRightIcon className="h-5 w-5 text-gray-400" aria-hidden="true"/>
                            </PageButton>
                            <PageButton
                                className="rounded-r-md"
                                onClick={() => gotoPage(pageCount - 1)}
                                disabled={!canNextPage}
                            >
                                <span className="sr-only">Last</span>
                                <ChevronDoubleRightIcon className="h-5 w-5 text-gray-400" aria-hidden="true"/>
                            </PageButton>
                        </nav>
                    </div>
                </div>
            </div>
        </>
    )
}

export default Table;